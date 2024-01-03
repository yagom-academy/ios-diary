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
        view.backgroundColor = .white
        setupNavigationBar()
        setupTableView()
    }
    
    //MARK: - Helper
    private func setupNavigationBar() {
        let apearance = UINavigationBarAppearance()
        apearance.configureWithOpaqueBackground()
        apearance.backgroundColor = .red
        
        navigationItem.title = "일기장"
        navigationController?.navigationBar.standardAppearance = apearance
        navigationController?.navigationBar.compactAppearance = apearance
        navigationController?.navigationBar.scrollEdgeAppearance = apearance
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
    }
}
