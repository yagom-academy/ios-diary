//
//  Diary - DiaryViewController.swift
//  Created by rilla, songjun.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var dataSource: UITableViewDiffableDataSource<Section, Diary>!
    
    private var diaries: [Diary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let decodedResult = DecodeManager().decodeJSON(fileName: "sample", type: [Diary].self)
        diaries = try? verifyResult(result: decodedResult)
        
        configureUI()
        configureLayout()
        configureViewController()
        configureCollectionView()
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
        view.addSubview(tableView)
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func configureViewController() {
        view.backgroundColor = .white
        self.title = "일기장"

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
    
    @objc private func presentAddingDiaryPage() {
        
    }
}

// MARK: - CollectionView
enum Section: CaseIterable {
    case main
}

extension DiaryViewController {
    private func configureCollectionView() {
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
}
