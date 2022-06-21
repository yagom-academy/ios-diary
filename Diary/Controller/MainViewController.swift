//
//  Diary - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

fileprivate extension AppConstants {
    static let navigationTitle = "일기장"
    static let deleteImage = "trash"
    static let shareImage = "person.crop.circle.badge.plus"
    
}

final class MainViewController: UIViewController {
    private lazy var mainView = MainView(frame: view.bounds)
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpDiaries()
    }
}

// MARK: SetUp

extension MainViewController {
    private func setUpNavigationBar() {
        title = AppConstants.navigationTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddButton)
        )
    }
    
    private func setUpTableView() {
        mainView.baseTableView.dataSource = self
        mainView.baseTableView.delegate = self
    }
    
    private func setUpDiaries() {
        DispatchQueue.main.async { [self] in
            PersistenceManager.shared.execute(by: .read)
            mainView.baseTableView.reloadData()
        }
    }
}

// MARK: Objc Method

extension MainViewController {
    @objc private func didTapAddButton() {
        let registrationVC = RegistrationViewController()
        navigationController?.pushViewController(registrationVC, animated: true)
    }
}

// MARK: UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PersistenceManager.shared.diaries().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryCell.identifier) as? DiaryCell else {
            return UITableViewCell()
        }
        
        cell.setUpContents(data: PersistenceManager.shared.diaries()[indexPath.row])
        
        return cell
    }
}

// MARK: UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let diary = PersistenceManager.shared.diaries()[safe: indexPath.row] else {
            return
        }
        
        let detailVC = DetailViewController(diary: diary)
        navigationController?.pushViewController(detailVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completionHandler in
            self?.showDeleteAlert(indexPath: indexPath)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: AppConstants.deleteImage)
        
        let shareAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completionHandler in
            self?.showActivityView(data: PersistenceManager.shared.diaries()[indexPath.row])
            completionHandler(true)
        }
        shareAction.image = UIImage(systemName: AppConstants.shareImage)
        shareAction.backgroundColor = .systemIndigo
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}

// MARK: Show Alert

extension MainViewController {
    private func showDeleteAlert(indexPath: IndexPath) {
        let UIAlertController = UIAlertController(
            title: AppConstants.deleteAlertTitle,
            message: AppConstants.deleteAlertMessage,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: AppConstants.cancelActionTitle, style: .cancel)
        let removeAction = UIAlertAction(title: AppConstants.deleteActionTitle, style: .destructive) { [self] _ in
            let objectToDelete = PersistenceManager.shared.diaries()[indexPath.row]
            PersistenceManager.shared.execute(by: .delete(objectToDelete, index: indexPath.row))
            mainView.baseTableView.deleteRows(at: [indexPath], with: .fade)
        }
        UIAlertController.addAction(cancelAction)
        UIAlertController.addAction(removeAction)
        present(UIAlertController, animated: true)
    }
}

// MARK: Show Activity

extension MainViewController {
    private func showActivityView(data: DiaryEntity) {
        let textToShare: [Any] = [
            ShareActivityItemSource(
                title: data.title ?? AppConstants.noTitle,
                text: data.createdAt.formattedString)
        ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        present(activityViewController, animated: true)
    }
}
