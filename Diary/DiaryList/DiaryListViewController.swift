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
        configureNavigationBar()
        configureDiaryListView()
        diaryListView.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        diaryListView.tableView.reloadData()
    }
    
    // MARK: - Methods
    
    private func configureNavigationBar() {
        navigationItem.title = NameSpace.diary
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonDidTapped))
    }
    
    private func configureDiaryListView() {
        view.addSubview(diaryListView)
        diaryListView.translatesAutoresizingMaskIntoConstraints = false
        diaryListView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        diaryListView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        diaryListView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        diaryListView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
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
        guard let diaryTitle = CoreDataManager.shared.fetchedDiaries[indexPath.row].title,
              let diaryBody = CoreDataManager.shared.fetchedDiaries[indexPath.row].body else { return }
        let diaryViewController = DiaryViewController()
        diaryViewController.diaryView.diaryTextView.text = nil
        diaryViewController.diaryView.diaryTextView.textColor = .black
        if diaryBody != "" {
            let attributedString = setAttributedString(indexPath: indexPath.row)
            diaryViewController.diaryView.diaryTextView.attributedText = attributedString
        } else {
            diaryViewController.diaryView.diaryTextView.text = diaryTitle
        }
        
        diaryViewController.indexPath = indexPath
        diaryViewController.mode = .modify
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
    
    private func setAttributedString(indexPath: Int) -> NSMutableAttributedString {
        guard let diaryTitle = CoreDataManager.shared.fetchedDiaries[indexPath].title,
              let diaryBody = CoreDataManager.shared.fetchedDiaries[indexPath].body else { return NSMutableAttributedString() }
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: diaryTitle + "\n\n", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)])
        attributedString.append(NSMutableAttributedString(string: diaryBody, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]))
        
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
}
