//
//  Diary - DiaryListViewController.swift
//  Created by SeHong.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class DiaryListViewController: UIViewController {
    
    private enum NavigationConstant {
        static let navigationTitle = "일기장"
        static let plusIcon = "plus"
    }

    private let coreDataManager = CoreDataManager()
    
    private var diaryItems = [Diary]()
    
    private var diaryListTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(DiaryTableViewCell.self,
                           forCellReuseIdentifier: DiaryTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .coreDataChanged, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        setupLayout()
        setupNotification()
        reloadDataIfNeeded()
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataIfNeeded), name: .coreDataChanged, object: nil)
    }
    
    private func handleCoreDataError(_ error: CoreDataError) {
        print("Error: \(error.description)")
        
        let alertController = UIAlertController(
            title: "에러발생",
            message: error.userErrorMessage,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "확인",
            style: .default,
            handler: nil
        )
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    @objc private func reloadDataIfNeeded() {
        let result = coreDataManager.getDiaryListFromCoreData()
        
        switch result {
        case .success(let diaryItems):
            self.diaryItems = diaryItems
            diaryListTableView.reloadData()
        case .failure(let error):
            handleCoreDataError(error)
        }
    }
    
    private func setupTableView() {
        diaryListTableView.dataSource = self
        diaryListTableView.delegate = self
    }
    
    private func setupNavigationBar() {
        title = NavigationConstant.navigationTitle
        let addButton = UIBarButtonItem(
            image: UIImage(systemName: NavigationConstant.plusIcon),
            style: .plain,
            target: self,
            action: #selector(createDiaryButtonTapped)
          )
          navigationItem.setRightBarButton(addButton, animated: false)
        
    }
    
    @objc func createDiaryButtonTapped() {
        let createDiaryViewController = DiaryDetailViewController()
        navigationController?.pushViewController(createDiaryViewController, animated: true)
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(diaryListTableView)
        
        NSLayoutConstraint.activate([
            diaryListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            diaryListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            diaryListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            diaryListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func handleNetworkError(_ error: CoreDataError) {
        print("Error: \(error.description)")
        
        let alertController = UIAlertController(
            title: nil,
            message: error.userErrorMessage,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "확인",
            style: .default,
            handler: nil
        )
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    private func delete(diaryData: Diary) {
        let result = coreDataManager.deleteDiaryData(data: diaryData)
        switch result {
        case .success:
            print("삭제 성공")
        case .failure(let error):
            print("\(error.userErrorMessage)")
            handleNetworkError(error)
        }
    }
    
    private func createDeleteAction(at indexPath: IndexPath, tableView: UITableView) -> UIContextualAction {
        return UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }

            if let selectedItem = self.diaryItems[safe: indexPath.row] {
                self.delete(diaryData: selectedItem)
                tableView.reloadData()
            }
            
            completionHandler(true)
        }
    }

    private func createShareAction(at indexPath: IndexPath) -> UIContextualAction {
        return UIContextualAction(style: .normal, title: "Share") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }

            if let selectedItem = self.diaryItems[safe: indexPath.row] {
                self.share(someText: selectedItem.title)
            }
            
            completionHandler(true)
        }
    }

}

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return diaryItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DiaryTableViewCell.identifier,
            for: indexPath) as? DiaryTableViewCell else { return UITableViewCell() }
        cell.accessoryType = .disclosureIndicator

        if let selectedItem = self.diaryItems[safe: indexPath.row] {
            cell.configureCell(selectedItem)
        }

        return cell
    }

}

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let selectedDiaryItem = diaryItems[safe: indexPath.row] {
            let detailViewController = DiaryDetailViewController(diary: selectedDiaryItem)
            navigationController?.pushViewController(detailViewController, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = createDeleteAction(at: indexPath, tableView: tableView)
        let shareAction = createShareAction(at: indexPath)

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
