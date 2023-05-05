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

    private let coreDataManager = CoreDataManager.shared
    
    private var diaryListTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(DiaryTableViewCell.self,
                           forCellReuseIdentifier: DiaryTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private var diaryItems = [Diary]()
    
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
    
    @objc private func reloadDataIfNeeded() {
        diaryItems = coreDataManager.getDiaryListFromCoreData()
        diaryListTableView.reloadData()
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
    
    private func handleNetworkError(_ error: NetworkError) {
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

    private func deleteDiary(diaryData: Diary?) {
        guard let diaryData else { return }
        coreDataManager.deleteDiaryData(data: diaryData)
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

        let diaryData = coreDataManager.getDiaryListFromCoreData()
        diaryData[safe: indexPath.row].map {
            cell.configureCell($0)
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
        diaryItems[safe: indexPath.row].map {
            let detailViewController = DiaryDetailViewController(diaryData: $0)
            navigationController?.pushViewController(detailViewController, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self else { return }
            
            self.diaryItems[safe: indexPath.row].map {
                self.deleteDiary(diaryData: $0)
                tableView.reloadData()
            }
            
            completionHandler(true)
        }
        
        let shareAction = UIContextualAction(style: .normal, title: "Share") { [weak self] (action, view, completionHandler) in
            guard let self else { return }
            
            self.diaryItems[safe: indexPath.row].map {
                self.shareText($0.title)
            }
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

}
