//
//  Diary - DiaryListViewController.swift
//  Created by Hugh, Derrick on 2022/08/16.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<Section, DiaryContent>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, DiaryContent>
    
    enum Section {
        case main
    }
    
    private lazy var dataSource = self.configureDataSource()
    
    private var diaryListViewModel = DiaryViewModel()
    
    private let diaryListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefault()
        configureLayout()
        updateDataSource(data: diaryListViewModel.diaryContents)
    }
    
    private func setupDefault() {
        self.view.backgroundColor = .white
        self.diaryListTableView.delegate = self
        
        self.title = "일기장"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTappedAddButton))
    }

    private func configureDataSource() -> DataSource {
        dataSource = DataSource(tableView: diaryListTableView, cellProvider: { tableView, indexPath, content -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.identifier, for: indexPath) as? DiaryTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configureUI(data: content)
            cell.accessoryType = .disclosureIndicator
            
            return cell
        })
        
        return dataSource
    }
    
    private func updateDataSource(data: [DiaryContent]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        
        dataSource.apply(snapshot)
    }
    
    private func configureLayout() {
        self.view.addSubview(diaryListTableView)
        
        NSLayoutConstraint.activate([
            diaryListTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            diaryListTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            diaryListTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            diaryListTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
    private func registerNotificationForTableView() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadTableView),
                                               name: .diaryContent,
                                               object: nil)
    }
    
    @objc private func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let data = self?.diaryListViewModel.diaryContents as? [DiaryContent] else {
                return
            }
            
            self?.updateDataSource(data: data)
            self?.diaryListTableView.reloadData()
        }
    }
    
    @objc private func didTappedAddButton() {
        let addDiaryViewController = DiaryPostViewController()
        
        self.navigationController?.pushViewController(addDiaryViewController, animated: true)
    }
}

// MARK: TableVeiwDelegate

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diaryContentViewController = DiaryContentViewController()
        diaryContentViewController.diaryViewModel = DiaryViewModel(data: diaryListViewModel.diaryContents[indexPath.row])
        
        self.navigationController?.pushViewController(diaryContentViewController, animated: true)
    }
}
