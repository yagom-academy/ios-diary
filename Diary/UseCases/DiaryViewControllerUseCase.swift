//
//  DiaryViewControllerUseCase.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/08/28.
//

import Foundation

protocol DiaryViewControllerUseCaseDelegate: AnyObject {
    func showErrorAlert(error: Error)
}

struct DiaryViewControllerUseCase {
    private(set) var diaryList: [Diary] = []
    weak var delegate: DiaryViewControllerUseCaseDelegate?
    let diaryPersistentManager: DiaryPersistentManager
    
    mutating func fetchDiaryList() {
        do {
            let diaryEntities = try diaryPersistentManager.fetch()
            diaryList = diaryEntities.map { diaryEntity in
                guard let title = diaryEntity.title,
                      let body = diaryEntity.body,
                      let createdDate = diaryEntity.createdDate else {
                    return Diary(
                        identifier: UUID(),
                        title: NameSpace.empty,
                        body: NameSpace.empty,
                        createdDate: NameSpace.empty
                    )
                }
                return Diary(
                    identifier: UUID(),
                    title: title,
                    body: body,
                    createdDate: createdDate
                )
            }
        } catch {
            delegate?.showErrorAlert(error: error)
        }
    }
    
    func upsert(_ diary: Diary) {
        do {
            if try diaryPersistentManager.isExist(diary) {
                try diaryPersistentManager.update(diary)
            } else {
                try diaryPersistentManager.insert(diary)
            }
        } catch {
            delegate?.showErrorAlert(error: error)
        }
    }
    
    func delete(_ diary: Diary) {
        do {
            try diaryPersistentManager.delete(diary.identifier)
        } catch {
            delegate?.showErrorAlert(error: error)
        }
    }

    func newDiary() -> Diary {
        let dateManager = DateManager()
        let diary = Diary(
            identifier: UUID(),
            title: NameSpace.empty,
            body: NameSpace.empty,
            createdDate: dateManager.todayString()
        )
        
        return diary
    }
}

extension DiaryViewControllerUseCase {
    private enum NameSpace {
        static let empty = ""
    }
}
