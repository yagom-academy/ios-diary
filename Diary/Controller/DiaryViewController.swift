//
//  Diary - DiaryViewController.swift
//  Created by rilla, songjun.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryViewController: UIViewController {
    private enum LocalizationKey {
        static let mainTitle = "mainTitle"
    }
    
    private var diaries: [Diary]?
    
    private var dataSource: UITableViewDiffableDataSource<Section, Diary>!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decodeDiaryData()
        configureUI()
        configureLayout()
        configureTableView()
    }
    
    private func decodeDiaryData() {
        let decodedResult = DecodeManager().decodeJSON(fileName: "sample", type: [Diary].self)
        diaries = try? verifyResult(result: decodedResult)
    }
    
    private func verifyResult<T, E: Error>(result: Result<T, E>) throws -> T? {
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        self.title = String.localized(key: LocalizationKey.mainTitle)
        
        let buttonItem: UIBarButtonItem = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "plus"), for: .normal)
            button.addTarget(self,
                             action: #selector(presentAddingDiaryPage),
                             for: .touchUpInside)
            let barButton = UIBarButtonItem(customView: button)
            
            return barButton
        }()
        
        self.navigationItem.rightBarButtonItem = buttonItem
    }
    
    private func configureLayout() {
        view.addSubview(tableView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    @objc private func presentAddingDiaryPage() {
        let diaryDetailViewController = DiaryDetailViewController(nil)
        
        self.navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
}

// MARK: - TableView
enum Section: CaseIterable {
    case main
}

extension DiaryViewController: UITableViewDelegate {
    private func configureTableView() {
        tableView.delegate = self
        configureDataSource()
        applySnapshot()
    }
    
    private func configureDataSource() {
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.reuseIdentifier)
        
        dataSource = UITableViewDiffableDataSource<Section, Diary>(tableView: tableView, cellProvider: { tableView, indexPath, diary in
            let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.reuseIdentifier, for: indexPath) as? DiaryTableViewCell
            
            cell?.configureCell(diary: diary)
            
            return cell
        })
    }
    
    private func applySnapshot() {
        guard diaries != nil else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Diary>()
        snapshot.appendSections([.main])
        snapshot.appendItems(diaries!)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let diary = diaries?[safe: indexPath.row]
        let diaryDetailViewController = DiaryDetailViewController(diary)
        
        self.navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
}
