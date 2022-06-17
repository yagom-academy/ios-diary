//
//  DiaryListDataSource.swift
//  Diary
//
//  Created by 이시원 on 2022/06/17.
//

import UIKit

final class DiaryListDataSource: UITableViewDiffableDataSource<Section, Diary> {
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Diary>
    
    private let persistentManager = PersistentManager(entityName: "DiaryEntity")
    private var items: [Diary] = [] {
        didSet {
            applySnapshot(items: items)
        }
    }
    
    private func applySnapshot(items: [Diary]) {
        var snapShot = Snapshot()
        snapShot.appendSections([.main])
        snapShot.appendItems(items)
        self.apply(snapShot)
    }
    
    func makeData() throws {
        items = try persistentManager.fetch()
    }
}
