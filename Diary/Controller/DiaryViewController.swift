//
//  Diary - DiaryViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
//  last modified by Mary & Whales

import UIKit

final class DiaryViewController: UIViewController {
    private let diaryManager = DiaryManager()
    private var diaryContents: [DiaryContent]?
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureTableView()
        setUpConstraints()
        fetchData()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        configureNavigationItem()
    }
    
    private func configureNavigationItem() {
        let addDiaryBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                    target: self,
                                                    action: #selector(addDiary))
        
        navigationItem.rightBarButtonItem = addDiaryBarButtonItem
        navigationItem.title = "일기장"
    }
    
    @objc private func addDiary() {
        let today = DiaryDateFormatter().format(from: Date(), by: "yyyyMMMd")
        
        showEditingDiaryViewController(date: today)
    }
    
    private func showEditingDiaryViewController(date: String) {
        let editingDiaryViewController = EditingDiaryViewController(createdDate: date)
        
        show(editingDiaryViewController, sender: self)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func fetchData() {
        diaryContents = diaryManager.fetchDiaryContents(name: "sample")
    }
}

extension DiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryContents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                as? DiaryTableViewCell
        else {
            return UITableViewCell()
        }
        
        guard let diaryContents = diaryContents else {
            return UITableViewCell()
        }
        
        cell.configureCell(data: diaryContents[indexPath.row])

        return cell
    }
}

extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let diaryContents = diaryContents else { return }
        
        showEditingDiaryViewController(date: diaryContents[indexPath.row].date)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
