//
//  DiaryTableViewDataSource.swift
//  Diary
//
//  Created by dudu, papri on 15/06/2022.
//

import UIKit

final class DiaryTableViewDataSource: UITableViewDiffableDataSource<Int, Diary> {
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Diary>
    
    private(set) var diarys = [Diary]() {
        didSet {
            makeSnapshot()
        }
    }
    
    private func makeSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(diarys)
        
        apply(snapshot)
    }
    
    func create() {
        let newDiary = Diary(title: "", body: "", createdDate: Date.now)
        diarys.insert(newDiary, at: .zero)
        PersistantManager.shared.create(data: newDiary)
    }
    
    func read() {
        guard let results = PersistantManager.shared.fetchAll() else { return }
        
        diarys = results.map { entity in
            return Diary(title: entity.title, body: entity.body, createdDate: entity.createdDate, id: entity.id)
        }
    }
    
    func update(diary: Diary) {
        guard let index = find(id: diary.id) else { return }
    
        diarys[index] = diary
        PersistantManager.shared.update(data: diary)
    }
    
    func delete(diary: Diary) {
        guard let index = find(id: diary.id) else { return }
    
        diarys.remove(at: index)
        PersistantManager.shared.delete(data: diary)
    }
    
    private func find(id: String) -> Int? {
        return diarys.firstIndex { $0.id == id }
    }
}
