//
//  Diary - DiaryListViewController.swift
//  Created by safari, Eddy.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

enum Section {
    case main
}

final class DiaryListViewController: UITableViewController, diaryDetailViewDelegate {
    private typealias DataSource = DiaryListDataSource
    
    private lazy var alertBuilder = AlertBuilder(target: self)
    private var dataSource: DataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureDataSource()
        configureNavigationItem()
    }
    
    private func configureDataSource() {
        dataSource = makeDataSource()
        
        do {
            try dataSource?.makeData()
        } catch {
            alertBuilder.addAction("확인", style: .default) {}
                .show("데이터를 읽어오지 못했습니다", message: nil, style: .alert)
        }
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
        let presentView = DiaryDetailViewController()
        presentView.delegate = self
        navigationController?.pushViewController(presentView, animated: true)
    }
    
    func save(_ diary: Diary) {
        do {
            try dataSource?.saveData(diary)
        } catch {
            alertBuilder.addAction("확인", style: .default) {}
                .show("데이터를 저장하지 못했습니다", message: nil, style: .alert)
        }
    }
    
    func update(_ diary: Diary) {
        do {
            try dataSource?.updateData(diary)
        } catch {
            alertBuilder.addAction("확인", style: .default) {}
                .show("데이터를 수정하지 못했습니다", message: nil, style: .alert)
        }
    }
    
    func delete(_ diary: Diary) {
        do {
            try dataSource?.deleteData(diary)
        } catch {
            alertBuilder.addAction("확인", style: .default) {}
                .show("데이터를 삭제하지 못했습니다", message: nil, style: .alert)
        }
    }
}

// MARK: - DataSource

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
}

// MARK: - TableView Delegate

extension DiaryListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let diary = dataSource?.snapshot().itemIdentifiers[indexPath.row] else { return }
        let presentView = DiaryDetailViewController(diary: diary)
        presentView.delegate = self
        navigationController?.pushViewController(presentView, animated: true)
    }
}
