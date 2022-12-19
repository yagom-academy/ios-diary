//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {
    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    private var dataSource: UITableViewDiffableDataSource<Int, Int>?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationItem.title = "example"
        configureTableViewLayout()
        
        setUpTableViewDataSource()
        setTableViewData()
    }

    private func configureTableViewLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func setUpTableViewDataSource() {
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        dataSource = UITableViewDiffableDataSource<Int, Int>(
            tableView: tableView
        ) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CustomCell.identifier,
                for: indexPath
            ) as? CustomCell else {
                return UITableViewCell()
            }
            cell.textLabel?.text = item.description
            
            return cell
        }
    }
    
    private func setTableViewData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0])
        snapshot.appendItems(Array(1...10))
        dataSource?.apply(snapshot)
    }
}

class CustomCell: UITableViewCell {
    static let identifier = String(describing: CustomCell.self)
}
