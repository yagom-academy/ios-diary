//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryTableViewController: UIViewController {
    private let diaryListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 70
        tableView.register(cellWithClass: DiaryListCell.self)
        return tableView
    }()
    
    private var diaryItems: [DiaryItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationItem()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        diaryListTableView.reloadData()
    }
    
    @objc private func addDiaryButtonDidTapped() {
        self.performSegue(withIdentifier: "AddDiarySegue", sender: self)
    }
    
    private func configureNavigationItem() {
        navigationItem.title = "일기장"
        let addDiaryButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addDiaryButtonDidTapped))
        navigationItem.rightBarButtonItem = addDiaryButton
    }
    
    private func configureTableView() {
        self.view.addSubview(diaryListTableView)
        setConstraint()
        diaryListTableView.dataSource = self
        diaryListTableView.delegate = self
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            diaryListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            diaryListTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            diaryListTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            diaryListTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func fetchData() {
        guard let diaryEntities = CoreDataManager.shared.fetchDiary() else { return }
        
        diaryItems = diaryEntities.map {
            DiaryItem(entity: $0)
        }
        
        diaryItems.reverse()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ManageDiarySegue" {
            guard let manageViewController = segue.destination as? ManageDiaryViewController else { return }
            guard let diary = sender as? DiaryItem else { return }
            manageViewController.getDiaryData(data: diary)
        }
    }
}

extension DiaryTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.diaryListTableView.dequeueReusableCell(withIdentifier: DiaryListCell.reuseIdentifier, for: indexPath) as? DiaryListCell else { return UITableViewCell() }
        
        cell.accessoryType = .disclosureIndicator
        cell.configure(with: diaryItems[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ManageDiarySegue", sender: diaryItems[indexPath.row])
    }
}
