//
//  Diary - DiaryListViewController.swift
//  Created by Rhode, 무리.
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreData

final class DiaryListViewController: UIViewController {
    private var coreDataManager = CoreDataManager.shared
    private var diaries: [Diary]? {
        return coreDataManager.readDiary()
    }
    
    let diaryListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(DiaryListCell.self, forCellReuseIdentifier: DiaryListCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSubview()
        configureConstraint()
        addObserver()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(forName: .init("reload"), object: nil, queue: .main) { _ in
            self.diaryListTableView.reloadData()
            self.diaryListTableView.layoutIfNeeded()
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        title = NameSpace.diary
        
        diaryListTableView.dataSource = self
        diaryListTableView.delegate = self
        
        let addDiaryButton = UIBarButtonItem(barButtonSystemItem: .add,
                                             target: self,
                                             action: #selector(addDiary))
        navigationItem.rightBarButtonItem = addDiaryButton
    }
    
    @objc
    private func addDiary() {
        let detailDiaryViewController = DetailDiaryViewController(isCreateDiary: true,
                                                                  isSaveRequired: true)
        navigationController?.pushViewController(detailDiaryViewController, animated: true)
    }
    
    private func configureSubview() {
        view.addSubview(diaryListTableView)
    }
    
    private func configureConstraint() {
        NSLayoutConstraint.activate([
            diaryListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            diaryListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let diaries else { return 0 }
        
        return diaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryListCell.identifier) as? DiaryListCell else {
            return DiaryListCell()
        }
        
        cell.iconImage.image = nil
        cell.accessoryType = .disclosureIndicator
        
        guard let diaries else { return DiaryListCell() }
        
        cell.configureContent(data: diaries[indexPath.row])
        
        return cell
    }
}

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailDiaryViewController = DetailDiaryViewController(isCreateDiary: false,
                                                                  isSaveRequired: true)
        navigationController?.pushViewController(detailDiaryViewController, animated: true)
        
        guard let diaries else { return }
        
        detailDiaryViewController.configureContent(diary: diaries[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let diaries else { return nil }
        
        let share = UIContextualAction(style: .normal, title: NameSpace.share) { action, view, completionHandler in
            let title = diaries[indexPath.row].title
            let body = diaries[indexPath.row].body
            
            ActionController.showActivityViewController(from: self,
                                                        title: title,
                                                        body: body)
            completionHandler(true)
            
        }
        
        let delete = UIContextualAction(style: .destructive, title: NameSpace.delete) { action, view, completionHandler in
            let diaryToDelete = diaries[indexPath.row]
            
            do {
                try self.coreDataManager.deleteDiary(diary: diaryToDelete)
            } catch {
                let alert = UIAlertController(title: "알림", message: "\(error)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return UISwipeActionsConfiguration(actions: [delete, share])
    }
}

private enum NameSpace {
    static let diary = "일기장"
    static let share = "공유"
    static let delete = "삭제"
    static let newline = "\n"
}
