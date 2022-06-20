//
//  Diary - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

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
    
    private func setUpNavigationBar() {
        title = "일기장"
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
    
    @objc private func didTapAddButton() {
        let registrationVC = RegistrationViewController()
        navigationController?.pushViewController(registrationVC, animated: true)
    }
}

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
        let removeAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completionHandler in
            self?.showRemoveAlert(indexPath: indexPath)
            completionHandler(true)
        }
        
        removeAction.image = UIImage.init(systemName: "trash")
        
        let shareAction = UIContextualAction(style: .normal, title: "공유") { [weak self] _, _, completionHandler in
            self?.showActivityView(data: PersistenceManager.shared.diaries()[indexPath.row])
            completionHandler(true)
        }
        shareAction.image = UIImage.init(systemName: "person.crop.circle.badge.plus")
        shareAction.backgroundColor = .systemIndigo
        
        return UISwipeActionsConfiguration(actions: [removeAction, shareAction])
    }
    
    private func showRemoveAlert(indexPath: IndexPath) {
        let UIAlertController = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let removeAction = UIAlertAction(title: "삭제", style: .destructive) { [self] _ in
            PersistenceManager.shared.deleteData(object: PersistenceManager.shared.diaries()[indexPath.row])
            PersistenceManager.shared.deleteData(index: indexPath.row)
            mainView.baseTableView.deleteRows(at: [indexPath], with: .fade)
        }
        UIAlertController.addAction(cancelAction)
        UIAlertController.addAction(removeAction)
        present(UIAlertController, animated: true)
    }
    
    private func showActivityView(data: DiaryEntity) {
        let textToShare: [Any] = [
            ShareActivityItemSource(
                title: data.title ?? "제목 없음",
                text: data.createdAt.formattedString)
        ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        present(activityViewController, animated: true)
    }
}
