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
    let error: ColdObservable<DiaryError> = .init()
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
        do {
            try PersistenceManager.shared.fetchData()
        } catch {
            self.error.onNext(value: .loadFail)
        }
        
    }
    
    private func deleteDiary(by indexPath: IndexPath) {
        guard let diary = diaries[safe: indexPath.row] else {
            return
        }
        let objectToDelete = diary
        
        do {
            try PersistenceManager.shared.deleteData(by: objectToDelete, index: indexPath.row)
        } catch {
            self.error.onNext(value: .deleteFail)
        }
        
    }
}
