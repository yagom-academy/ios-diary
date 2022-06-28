//
//  MainViewModel.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/22.
//

import Foundation

final class MainViewModel {
    var diaries: [DiaryEntity] {
        return PersistenceManager.shared.diaryEntities
    }
}

extension MainViewModel {
    
    // MARK: Input
    
    func viewWillAppear() throws {
        try readDiary()
    }
    
    func didTapDeleteButton(by indexPath: IndexPath) throws {
        try deleteDiary(by: indexPath)
    }
    
    // MARK: Output
    
    private func readDiary() throws {
        try PersistenceManager.shared.fetchData()
    }
   
    private func deleteDiary(by indexPath: IndexPath) throws {
        guard let diary = diaries[safe: indexPath.row] else {
            return
        }
        let objectToDelete = diary
        try PersistenceManager.shared.deleteData(by: objectToDelete, index: indexPath.row)
    }
}
