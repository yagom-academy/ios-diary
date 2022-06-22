//
//  MainViewModel.swift
//  Diary
//
//  Created by 조민호 on 2022/06/22.
//

import Foundation

final class MainViewModel {
    var diaries: [DiaryEntity] {
        return PersistenceManager.shared.diaryEntities
    }
}

extension MainViewModel {
    func readDiary() {
        PersistenceManager.shared.fetchData()
    }
    
    func deleteDiary(indexPath: IndexPath) {
        guard let diary = diaries[safe: indexPath.row] else {
            return
        }
        let objectToDelete = diary
        PersistenceManager.shared.deleteData(by: objectToDelete, index: indexPath.row)
    }
}
