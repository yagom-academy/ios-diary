//
//  Diary - DiaryListViewController.swift
//  Created by Finnn, 수꿍 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

enum Section {
    case main
}

final class DiaryListViewController: UIViewController {
    
    // MARK: - Properties

    private let diaryView = DiaryListView()
    private var dataSource: UITableViewDiffableDataSource<Section, Diary>?
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Diary>()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = diaryView
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItems()
        registerTableView()
        configureDataSource()
        configureDelgate()
    }
    
    // MARK: - Methods
    
    private func presentErrorAlert(_ error: (Error)) {
        let errorAlert = UIAlertController(
            title: AlertMessage.errorAlertTitle,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(
            title: AlertMessage.confirmActionTitle,
            style: .default
        )
        
        errorAlert.addAction(confirmAction)
        
        present(
            errorAlert,
            animated: true
        )
    }
    
    private func configureNavigationItems() {
        title = NavigationItem.diaryTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: SystemImage.plus),
            style: .plain,
            target: self,
            action: #selector(plusButtonTapped)
        )
    }
    
    @objc private func plusButtonTapped() {
        moveToDiaryContentsViewController()
    }
    
    private func moveToDiaryContentsViewController() {
        navigationController?.pushViewController(
            DiaryContentsViewController(),
            animated: true
        )
    }
    
    private func registerTableView() {
        let tableView = diaryView.tableView
        
        tableView.register(
            DiaryListCell.self,
            forCellReuseIdentifier: DiaryListCell.identifier
        )
        tableView.dataSource = dataSource
    }
    
    private func configureDataSource() {
        configureSnapshot()
        
        let tableView = diaryView.tableView
        
        dataSource = UITableViewDiffableDataSource<Section, Diary>(
            tableView: tableView,
            cellProvider: { tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: DiaryListCell.identifier,
                    for: indexPath
                ) as? DiaryListCell else {
                    return nil
                }
                
                cell.titleLabel.text = item.title
                cell.dateLabel.text = item.createdAt?.localizedString
                cell.contentLabel.text = item.body
                cell.accessoryType = .disclosureIndicator
                
                return cell
            }
        )
        
        dataSource?.apply(snapshot)
    }
    
    private func configureSnapshot() {
        guard let diaries = CoreDataManager.shared.fetchAllDiary() else {
            return
        }
        
        snapshot.appendSections([.main])
        snapshot.appendItems(diaries)
    }
    
    private func configureDelgate() {
        diaryView.tableView.delegate = self
    }
}

// MARK: - UITableViewDelegate

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )
    }
}
