//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    //MARK: - Property
    private let coreDataManager = CoreDataManager.shared
    private var diaryData: [DiaryData] = []
    
    private let tableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupTableViewConstraints()
        readDiaryData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readDiaryData()
        tableView.reloadData()
    }
    
    //MARK: - Helper
    private func readDiaryData() {
        diaryData = coreDataManager.readDiaryData()
        tableView.reloadData()
    }
    
    private func setupNavigationBar() {
        let apearance = UINavigationBarAppearance()
        apearance.configureWithOpaqueBackground()
        apearance.backgroundColor = .white
        
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewDiary))
        navigationController?.navigationBar.standardAppearance = apearance
        navigationController?.navigationBar.compactAppearance = apearance
        navigationController?.navigationBar.scrollEdgeAppearance = apearance
    }
    
    @objc private func addNewDiary() {
        let diaryContentsViewController = DiaryContentsViewController()
        coreDataManager.createDiaryData()
        
        diaryContentsViewController.diaryData = coreDataManager.readDiaryData().last
        navigationController?.pushViewController(diaryContentsViewController, animated: true)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DiaryListCell.self, forCellReuseIdentifier: DiaryListCell.identifier)
    }
    
    private func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryListCell.identifier, for: indexPath) as? DiaryListCell else { return UITableViewCell() }
        
        cell.injectData(title: diaryData[indexPath.row].title, date: diaryData[indexPath.row].date, preview: diaryData[indexPath.row].body)
        cell.injectAccessoryType(to: .disclosureIndicator)
        
        return cell
    }
}

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diaryContentsViewController = DiaryContentsViewController()
        diaryContentsViewController.diaryData = self.diaryData[indexPath.row]
        
        navigationController?.pushViewController(diaryContentsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let share = UIContextualAction(style: .normal, title: "Share") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            success(true)
        }
        share.backgroundColor = .systemBlue
        
        let delete = UIContextualAction(style: .destructive, title: "delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            success(true)
        }
        
        return UISwipeActionsConfiguration(actions: [delete, share])
    }
}
