//
//  Diary - DiaryMainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryMainViewController: UIViewController {
    private let diaryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
        
        return tableView
    }()
    
    private let persistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    private var diarylist: [DiaryEntity]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        diarylist = persistentContainer?.getAllItems()
        diaryTableView.reloadData()
    }
    
    private func configureDelegates() {
        diaryTableView.delegate = self
        diaryTableView.dataSource = self
    }
    
    @objc private func didTapAddDiaryButton() {
        guard let context = persistentContainer?.viewContext else { return }
        let diary = DiaryEntity(context: context)
        diary.createdAt = Date()
        
        let detailDiaryViewController = DetailDiaryViewController(diary: diary)
        
        self.navigationController?.pushViewController(detailDiaryViewController, animated: true)
    }
}

extension DiaryMainViewController {
    private func configureUI() {
        configureView()
        configureNavigationItem()
        addSubViews()
        diaryTableViewConstraints()
    }
    
    private func configureView() {
        self.view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationItem() {
        self.navigationItem.title = "일기장"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddDiaryButton))
    }
    
    private func addSubViews() {
        view.addSubview(diaryTableView)
    }
    
    private func diaryTableViewConstraints() {
        diaryTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            diaryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            diaryTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension DiaryMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let diarylist else {
            
            return .zero
        }
        
        return diarylist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.identifier, for: indexPath) as? DiaryTableViewCell else {
            
            return UITableViewCell()
        }
        
        guard let diarylist,
              let diary = diarylist[safe: indexPath.row] else {
            
            return UITableViewCell()
        }
        
        cell.fetchData(diary)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let diarylist,
              let diary = diarylist[safe: indexPath.row] else {
            
            return
        }
        
        let detailDiaryViewController = DetailDiaryViewController(diary: diary)
        navigationController?.pushViewController(detailDiaryViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let diarylist,
              let diary = diarylist[safe: indexPath.row] else {
            
            return UISwipeActionsConfiguration()
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.persistentContainer?.deleteItem(diary)
            self.diarylist = self.persistentContainer?.getAllItems()
            self.diaryTableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
