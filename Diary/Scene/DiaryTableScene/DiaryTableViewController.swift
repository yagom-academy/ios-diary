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
    
    private var diarys = [Diary]() {
        didSet {
            makeSnapshot()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        makeDataSource()
        makeSampleDiarys()
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
        let diaryViewController = DiaryViewController()
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    private func setUpTableView() {
        tableView.separatorInset.left = 20
        tableView.register(DiaryCell.self, forCellReuseIdentifier: DiaryCell.reuseIdentifier)
        makeDataSource()
    }
    
    private func makeDataSource() {
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DiaryCell.reuseIdentifier,
                for: indexPath
            ) as? DiaryCell
            
            cell?.setUpItem(with: item)
            return cell
        }
    }
    
    private func makeSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(diarys)
        
        dataSource?.apply(snapshot)
    }
    
    private func makeSampleDiarys() {
        guard let url = Bundle.main.url(forResource: "sample", withExtension: "json") else { return }
        
        do {
            let sampleData = try Data(contentsOf: url)
            diarys = try JSONDecoder().decode([Diary].self, from: sampleData)
        } catch {
            print(error)
        }
    }
}

// MARK: TableViewDelegate

extension DiaryTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diary = diarys[indexPath.row]
        let diaryViewController = DiaryViewController(diary: diary)
        
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
}
