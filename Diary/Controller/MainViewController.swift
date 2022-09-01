//
//  MainViewController.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/08/16.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let diaryManager = DiaryManager()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    private let diaryItemTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setNavigationbar()
        self.configureTableView()
        self.registerDiaryNotification()
        self.diaryManager.loadData()
    }
    
    private func setNavigationbar() {
        self.navigationItem.title = "일기장"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didAddDiaryButtonTapped))
    }
    
    @objc private func didAddDiaryButtonTapped() {
        navigationController?.pushViewController(DiaryViewController(), animated: true)
    }
    
    private func configureTableView() {
        self.diaryItemTableView.dataSource = self
        self.diaryItemTableView.delegate = self
        self.diaryItemTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(diaryItemTableView)
        
        NSLayoutConstraint.activate([
            self.diaryItemTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.diaryItemTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.diaryItemTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.diaryItemTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    private func registerDiaryNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTableView),
                                               name: .diaryModelDataDidChanged,
                                               object: nil)
    }
    
    @objc private func updateTableView() {
        self.diaryItemTableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryManager.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: diaryManager.content(index: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diaryDetailViewController = DiaryDetailViewController()
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
        
        diaryDetailViewController.setData(data: diaryManager.content(index: indexPath.row))
        diaryDetailViewController.setIndexNumber(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title: "공유") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            success(true)
            let shareText = self.diaryManager.fetchDiaryEntity()[indexPath.row]
            let shareObject = [shareText.title + ("\n") + shareText.body]
            let activityViewController = UIActivityViewController(activityItems: shareObject, applicationActivities: nil)
            
            self.present(activityViewController, animated: true)
        }
        
        shareAction.backgroundColor = .systemBlue
        
        let deleteAction = UIContextualAction(style: .normal, title: "삭제") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            success(true)
            let alert = UIAlertController(title: "진짜요?",
                                          message: "정말로 삭제하시겠어요?",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "취소", style: .default, handler: { _ in
                
            }))
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
                self.diaryManager.deleteDiary(id: self.diaryManager.fetchDiaryEntity()[indexPath.row].id)
            }))
            
            self.present(alert, animated: true)
        }
        
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}
