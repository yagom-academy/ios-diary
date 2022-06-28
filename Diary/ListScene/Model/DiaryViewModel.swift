//
//  DiaryViewModel.swift
//  Diary
//
//  Created by 김태현 on 2022/06/28.
//

import UIKit

final class DiaryViewModel {
    private var dataSource: UITableViewDiffableDataSource<Int, DiaryDTO>?
    
    func setUpDataSource(tableView: UITableView?) {
        guard let tableView = tableView else {
            return
        }
        
        dataSource = UITableViewDiffableDataSource<Int, DiaryDTO>(tableView: tableView) {
            tableView, indexPath, itemIdentifier in
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: DiaryCell.identifier, for: indexPath) as? DiaryCell {
                cell.configure(data: itemIdentifier)
                
                return cell
            }
            
            return tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        }
    }
    
    func setUpSampleData() {
        guard let sampleData: [DiaryDTO] = AssetManager.get() else {
            return
        }
        
        setUpSnapshot(data: sampleData)
    }
    
    func setUpCoreData(tableView: UITableView?) {
        guard let tableView = tableView,
              let coreData = DiaryDAO.shared.read() else {
            return
        }
        
        setUpSnapshot(data: coreData)
        
        tableView.refreshControl?.endRefreshing()
    }
    
    private func setUpSnapshot(data: [DiaryDTO]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, DiaryDTO>()
        
        snapshot.appendSections([.zero])
        snapshot.appendItems(data)
        
        dataSource?.apply(snapshot)
    }
    
    func getDataSource() -> UITableViewDiffableDataSource<Int, DiaryDTO>? {
        return dataSource
    }
    
    func updataTableView(tableView: UITableView?) {
        guard let tableView = tableView else {
            return
        }
        
        tableView.refreshControl?.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.setUpCoreData(tableView: tableView)
        }
    }
}
