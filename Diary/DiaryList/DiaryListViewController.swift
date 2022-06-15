//
//  Diary - DiaryListViewController.swift
//  Created by safari, Eddy.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

private enum Section {
    case main
}

final class DiaryListViewController: UITableViewController {
    private typealias DataSource = UITableViewDiffableDataSource<Section, Diary>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Diary>
    private var dataSource: DataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        dataSource = makeDataSource()
        applySnapshot(items: makeData())
        configureNavigationItem()
    }
    
    private func makeData() -> [Diary] {
        let items = Diary.createData() ?? []
        
        return items
    }
    
    private func configureTableView() {
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
    }
    
    private func configureNavigationItem() {
        self.title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonDidTapped))
    }
    
    @objc private func addButtonDidTapped() {
    }
}

extension DiaryListViewController {
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(tableView: self.tableView) { (tableView, indexPath, itemIdentifier) in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: DiaryTableViewCell.identifier,
                for: indexPath) as? DiaryTableViewCell else { return UITableViewCell() }
            
            cell.configure(item: itemIdentifier)
            
            return cell
        }
        
        return dataSource
    }
    
    private func applySnapshot(items: [Diary]) {
        var snapShot = Snapshot()
        snapShot.appendSections([.main])
        snapShot.appendItems(items)
        dataSource?.apply(snapShot)
    }
}

extension DiaryListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let diary = dataSource?.snapshot().itemIdentifiers[indexPath.row] else { return }
        navigationController?.pushViewController(DiaryDetailViewController(diary: diary), animated: true)
    }
}
