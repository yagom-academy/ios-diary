//
//  Diary - DiaryListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
 
    private var diaries: [Diary]?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        configureTableView()
        configureUI()
        configureNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        tableView.reloadData()
    }
    
    private func fetchData() {
        do {
            self.diaries = try CoreDataManager.shared.fetchDiaryList()
        } catch {
            print(error)
        }
    }
    
    private func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(DiaryCell.self, forCellReuseIdentifier: DiaryCell.identifier)
        self.tableView.reloadData()
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureNavigationItem() {
        self.navigationItem.title = Constant.listTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDiary))
    }
    
    @objc private func addDiary() {
        let addDiaryViewController = AddDiaryViewController()
        self.navigationController?.pushViewController(addDiaryViewController, animated: true)
    }
}

// MARK: - TableView Method
extension DiaryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryCell.identifier) as? DiaryCell else { return UITableViewCell() }
        let diary = diaries?[indexPath.row]
        cell.configureData(diary: diary)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diary = diaries?[indexPath.row]
        let editDiaryViewController = EditDiaryViewController(diary: diary)
        
        self.navigationController?.pushViewController(editDiaryViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let share = UIContextualAction(style: .normal, title: Constant.share) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            guard let diary = self.diaries?[indexPath.row] else {
                success(false)
                return
            }
            self.showActivityViewController(diary: diary)
            success(true)
        }
        share.backgroundColor = .systemBlue
        let delete = UIContextualAction(style: .normal, title: Constant.delete) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            guard let diary = self.diaries?[indexPath.row] else {
                success(false)
                return
            }
            self.showDeleteAlert(diary: diary)
            success(true)
        }
        
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete, share])
    }
}

// MARK: - Alert, ActivityViewController
extension DiaryListViewController {
    
    func showDeleteAlert(diary: Diary) {
        let alert = UIAlertController(title: Constant.deleteAlertTitle, message: Constant.deleteAlertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constant.delete, style: .destructive) { _ in
            do {
                try CoreDataManager.shared.deleteDiary(diary: diary)
            } catch {
                print(error)
            }
            self.fetchData()
            self.tableView.reloadData()
        })
                
        alert.addAction(UIAlertAction(title: Constant.cancel, style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showActivityViewController(diary: Diary) {
        let activityViewController = UIActivityViewController(activityItems: [diary.text], applicationActivities: nil)
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}
