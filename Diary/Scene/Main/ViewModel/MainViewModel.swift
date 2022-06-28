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
    
    func viewWillAppear() {
        readDiary()
    }
    
    func didTapDeleteButton(by indexPath: IndexPath) {
        deleteDiary(by: indexPath)
    }
    
    // MARK: Output
    
    private func readDiary() {
        PersistenceManager.shared.fetchData()
    }
   
    private func deleteDiary(by indexPath: IndexPath) {
        guard let diary = diaries[safe: indexPath.row] else {
            return
        }
        let objectToDelete = diary
        PersistenceManager.shared.deleteData(by: objectToDelete, index: indexPath.row)
    }
}
