//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {
    //MARK: - property
    private let tableView = UITableView()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupTableViewConstraints()
    }
    
    //MARK: - Helper
    private func setupNavigationBar() {
        let apearance = UINavigationBarAppearance()
        apearance.configureWithOpaqueBackground()
        apearance.backgroundColor = .white
        
        navigationItem.title = "일기장"
        navigationController?.navigationBar.standardAppearance = apearance
        navigationController?.navigationBar.compactAppearance = apearance
        navigationController?.navigationBar.scrollEdgeAppearance = apearance
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DiaryListCell.self, forCellReuseIdentifier: DiaryListCell.identifier)
    }
    
    private func setupTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryListCell.identifier, for: indexPath) as? DiaryListCell else { return UITableViewCell() }
        
        cell.titleLabel.text = "title"
        cell.dateLabel.text = "date"
        cell.previewLabel.text = "preview"
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {

}
