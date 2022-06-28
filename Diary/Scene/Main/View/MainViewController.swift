//
//  Diary - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    private enum Constants {
        static let navigationTitle = "일기장"
        static let deleteImage = "trash"
        static let shareImage = "person.crop.circle.badge.plus"
    }
    
    private lazy var mainView = MainView(frame: view.bounds, delegate: self, dataSource: self)
    private let viewModel = MainViewModel()
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearEvent()
        setUpDiaries()
    }
}

// MARK: SetUp
extension MainViewController {
    private func setUpNavigationBar() {
        title = Constants.navigationTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddButton)
        )
    }
    
    private func setUpDiaries() {
        DispatchQueue.main.async {
            self.mainView.reloadBaseTableView()
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
        return viewModel.diaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryCell.identifier) as? DiaryCell,
              let diary = viewModel.diaries[safe: indexPath.row]
        else {
            return UITableViewCell()
        }
        let cellViewModel = DiaryCellViewModel()
        cell.bind(viewModel: cellViewModel)
        cell.setUpContents(data: diary)
        return cell
    }
}

// MARK: UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let diary = viewModel.diaries[safe: indexPath.row] else {
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
            self?.showDeleteAlert(by: indexPath)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: Constants.deleteImage)
        
        let shareAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completionHandler in
            guard let diary = self?.viewModel.diaries[safe: indexPath.row] else {
                return
            }
            self?.showActivityView(data: diary)
            completionHandler(true)
        }
        shareAction.image = UIImage(systemName: Constants.shareImage)
        shareAction.backgroundColor = .systemIndigo
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}

// MARK: Show Alert
extension MainViewController {
    private func showDeleteAlert(by indexPath: IndexPath) {
        alertController.showDeleteAlert(presentedViewController: self) { [self] _ in
            didTapDeleteButtonEvent(by: indexPath)
            mainView.deleteBaseTableViewRows(at: [indexPath])
        }
    }
}

// MARK: Event Handle

extension MainViewController {
    private func viewWillAppearEvent() {
        do {
            try viewModel.viewWillAppear()
        } catch {
            alertController.showConfirmAlert(
                title: "오류",
                message: DiaryError.loadFail.errorDescription,
                presentedViewController: self
            )
        }
    }
    
    private func didTapDeleteButtonEvent(by indexPath: IndexPath) {
        do {
            try viewModel.didTapDeleteButton(by: indexPath)
        } catch {
            alertController.showConfirmAlert(
                title: "오류",
                message: DiaryError.loadFail.errorDescription,
                presentedViewController: self
            )
        }
    }
}
