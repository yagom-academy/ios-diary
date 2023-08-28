//
//  Diary - DiaryListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIObject()
        configureUI()
        setupConstraints()
    }
}

// MARK: - Setting UI Object
extension DiaryListViewController {
    private func setupUIObject() {
        setupView()
        setupTableView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - TableView DataSource
extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: - TableView Delegate
extension DiaryListViewController: UITableViewDelegate {
    
}

// MARK: - Configure UI
extension DiaryListViewController {
    private func configureUI() {
        configureView()
    }
    
    private func configureView() {
        view.addSubview(tableView)
    }
}

// MARK: - Setting Constraint
extension DiaryListViewController {
    private func setupConstraints() {
        setupTableViewConstraint()
    }
    
    private func setupTableViewConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
