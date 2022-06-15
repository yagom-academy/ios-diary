//
//  Diary - DiaryTableViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryTableViewController: UITableViewController {
    private var dataSource: DiaryTableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        setUpNavigationBar()
        setUpTableView()
    }
    
    private func setUpNavigationBar() {
        title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtondidTap)
        )
    }
    
    @objc
    private func addButtondidTap() {
        let diaryViewController = DiaryDetailViewController()
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    private func setUpTableView() {
        tableView.separatorInset.left = 20
        tableView.register(DiaryCell.self, forCellReuseIdentifier: DiaryCell.reuseIdentifier)
        makeDataSource()
        dataSource?.makeSampleDiarys()
    }
    
    private func makeDataSource() {
        dataSource = DiaryTableViewDataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DiaryCell.reuseIdentifier,
                for: indexPath
            ) as? DiaryCell
            
            cell?.setUpItem(with: item)
            return cell
        }
    }
}

// MARK: TableViewDelegate

extension DiaryTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diary = dataSource?.diarys[indexPath.row]
        let diaryViewController = DiaryDetailViewController(diary: diary)
        
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
}
