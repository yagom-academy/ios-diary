//
//  Diary - DiaryListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    // MARK: - Properties
    
    private let diaryListView = DiaryListView(frame: .zero)
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupDiaryListView()
        adaptDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        diaryListView.tableView.reloadData()
    }
    
    // MARK: - Methods
    
    private func setupNavigationBar() {
        navigationItem.title = NameSpace.diary
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonDidTapped))
    }
    
    private func setupDiaryListView() {
        view.addSubview(diaryListView)
        diaryListView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            diaryListView.topAnchor.constraint(equalTo: view.topAnchor),
            diaryListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            diaryListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            diaryListView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func adaptDelegate() {
        diaryListView.tableView.delegate = self
    }
    
    @objc func addButtonDidTapped() {
        let diaryViewController = DiaryViewController()
        diaryViewController.mode = .create
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diaryViewController = generateViewController(with: indexPath)
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = generateShareAction(with: indexPath)
        let deleteAction = generateDeleteAction(with: indexPath, in: tableView)
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}

// MARK: - UITableViewDelegate Support Methods

extension DiaryListViewController {
    
    private func setAttributedString(indexPath: IndexPath) -> NSMutableAttributedString {
        guard let diaryTitle = CoreDataManager.shared.fetchedDiaries[indexPath.row].title,
              let diaryBody = CoreDataManager.shared.fetchedDiaries[indexPath.row].body else { return NSMutableAttributedString() }
        let attributedString = NSMutableAttributedString(string: diaryTitle + "\n\n",
                                                         attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)])
        attributedString.append(NSMutableAttributedString(string: diaryBody,
                                                          attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]))
        
        return attributedString
    }
    
    func generateShareAction(with indexPath: IndexPath) -> UIContextualAction {
        let shareAction = UIContextualAction(style: .normal, title: "공유") { _, _, _ in
            let model = CoreDataManager.shared.fetchedDiaries
            let title = model[indexPath.row].title ?? "제목없음"
            let diaryToShare: [Any] = [MyActivityItemSource(title: title, text: model[indexPath.row].body!)]
            let activityViewController = UIActivityViewController(activityItems: diaryToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.diaryListView
            
            self.present(activityViewController, animated: true)
        }
        shareAction.image = UIImage(systemName: "person.crop.circle.badge.plus")
        shareAction.backgroundColor = .init(red: 80/255, green: 188/225, blue: 223/225, alpha: 1)
        return shareAction
    }
    
    func generateDeleteAction(with indexPath: IndexPath, in tableView: UITableView) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { _, _, _ in
            let diary = CoreDataManager.shared.fetchedDiaries[indexPath.row]
            CoreDataManager.shared.delete(diary: diary)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
        deleteAction.image = UIImage(systemName: "trash")
        return deleteAction
    }
    
    func generateViewController(with indexPath: IndexPath) -> UIViewController {
        guard let diaryTitle = CoreDataManager.shared.fetchedDiaries[indexPath.row].title,
              let diaryBody = CoreDataManager.shared.fetchedDiaries[indexPath.row].body else { return UIViewController() }
        
        let diaryViewController = DiaryViewController()
        diaryViewController.diaryView.diaryTextView.text = nil
        diaryViewController.diaryView.diaryTextView.textColor = .black
        diaryViewController.indexPath = indexPath
        diaryViewController.mode = .modify
        
        if diaryBody != "" {
            let attributedString = setAttributedString(indexPath: indexPath)
            diaryViewController.diaryView.diaryTextView.attributedText = attributedString
        } else {
            diaryViewController.diaryView.diaryTextView.text = diaryTitle
        }
        
        return diaryViewController
    }
}
