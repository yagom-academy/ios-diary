//
//  DiaryViewModel.swift
//  Diary
//
//  Created by 김태현 on 2022/06/28.
//

import UIKit

final class DiaryDataSource: UITableViewDiffableDataSource<Int, DiaryDTO> {
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
        
        apply(snapshot)
    }
}
