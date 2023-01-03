//
//  DiaryViewController.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/20.
//

import CoreData
import UIKit

final class DiaryViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var diaryContents: [DiaryData] = []

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupDiaryContents()
        self.tableView.reloadData()
    }
    
    private func setupDiaryContents() {
        let contents = DiaryDataStore.shared.fetch(request: Diary.fetchRequest())
        
        diaryContents = contents.sorted(
            by: { lhs, rhs in
                lhs.createdAt > rhs.createdAt
            }
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTableView()
        configureNavigationBar()
    }
    
    private func configureView() {
        self.view.addSubview(tableView)
        self.view.backgroundColor = .systemBackground
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func configureTableView() {
        self.tableView.register(DiaryListCell.self, forCellReuseIdentifier: DiaryListCell.identifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    private func configureNavigationBar() {
        self.navigationItem.title = Constant.diaryViewTitle.localized
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add)
        self.navigationItem.rightBarButtonItem?.target = self
        self.navigationItem.rightBarButtonItem?.action = #selector(tappedAddButton)
    }
    
    private func pushEditorViewController(with content: DiaryData) {
        let editorViewController = EditorViewController(with: content)
        
        self.navigationController?.pushViewController(editorViewController, animated: true)
    }
}

// MARK: - objc method
extension DiaryViewController {
    @objc private func tappedAddButton(_ sender: UIBarButtonItem) {
        guard let diaryData = DiaryDataStore.shared.generateDiary() else { return }
        
        pushEditorViewController(with: diaryData)
    }
}

// MARK: - tableView Delegate
extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        pushEditorViewController(with: diaryContents[indexPath.row])
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: AlertMessage.delete.localized
        ) { (_, _, completionHandler) in
            let diary = self.diaryContents[indexPath.row]
            self.diaryContents.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            DiaryDataStore.shared.delete(objectID: diary.objectID)
            
            completionHandler(true)
        }
        
        let shareAction = UIContextualAction(
            style: .normal,
            title: AlertMessage.share.localized
        ) { (_, _, completionHandler) in
            let diary = self.diaryContents[indexPath.row]
            let title = (diary.title ?? "")
            let body = (diary.body ?? "")
            let shareText: String = title + Constant.doubleBreak + body
            
            let activityViewController = UIActivityViewController(
                activityItems: [shareText],
                applicationActivities: nil
            )
            self.present(activityViewController, animated: true)
            
            completionHandler(true)
        }
        shareAction.backgroundColor = .systemPurple
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
    }
}

// MARK: - tableView DataSource
extension DiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryListCell.identifier) as? DiaryListCell
        else {
            return UITableViewCell()
        }
        cell.configure(with: diaryContents[indexPath.row])
        return cell
    }
}
