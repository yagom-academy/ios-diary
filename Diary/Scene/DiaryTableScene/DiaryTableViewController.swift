//
//  Diary - DiaryTableViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryTableViewController: UITableViewController {
    private typealias DataSource = UITableViewDiffableDataSource<Int, Diary>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Diary>
    private var dataSource: DataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        makeDataSource()
    }
    
    private func setUp() {
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        makeDataSource()
        makeSnapshot()
    }
    
    private func makeDataSource() {
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "아무거나"
            
            return cell
        }
    }
    
    private func makeSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems([])
        
        dataSource?.apply(snapshot)
    }
}
