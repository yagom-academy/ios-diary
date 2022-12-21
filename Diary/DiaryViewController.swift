//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
       return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableViewAttribute()
        configureTableViewConstraint()
    }
    
    private func configureTableViewConstraint() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func tableViewAttribute() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DiaryTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "diaryTableViewCell")
    }
}

// MARK: - TableView Delegate
extension DiaryViewController: UITableViewDelegate { }

// MARK: - TableView DataSource
extension DiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diaryTableViewCell",
                                                 for: indexPath) as? DiaryTableViewCell ?? DiaryTableViewCell()
        return cell
    }
}
