//
//  Diary - DiaryViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryViewController: UIViewController {
    enum Section {
        case main
    }
    
    let tableView = UITableView()
    var dataSource: UITableViewDiffableDataSource<Section, DiaryData>?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setUpDataSource()
        setUpTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setUpNavigationController()
        
        setUpTableViewLayout()
        
        guard let diaryData = AssetManager().getData() else {
            return
        }
        
        setUpSanpshot(data: diaryData)
    }
    
    private func setUpTableView() {
        tableView.register(DiaryCell.self, forCellReuseIdentifier: DiaryCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        tableView.dataSource = dataSource
    }
    
    private func setUpTableViewLayout() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setUpDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, DiaryData>(tableView: tableView) {
            tableView, indexPath, itemIdentifier in
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: DiaryCell.identifier, for: indexPath) as? DiaryCell {
                cell.configure(data: itemIdentifier)
                return cell
            }
            
            return tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        }
    }
    
    private func setUpSanpshot(data: [DiaryData]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DiaryData>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        
        dataSource?.apply(snapshot)
    }
    
    private func setUpNavigationController() {
        func setUpRightItem() {
            let weight = UIFont.systemFont(ofSize: 35, weight: .light)
            let attributes = [NSAttributedString.Key.font: weight]
            let registerButton = UIBarButtonItem()
            
            registerButton.title = "+"
            registerButton.setTitleTextAttributes(attributes, for: .normal)
            
            navigationItem.rightBarButtonItem = registerButton
        }
        
        navigationItem.title = "일기장"
        setUpRightItem()
    }
}
