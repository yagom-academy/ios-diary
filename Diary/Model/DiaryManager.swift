//
//  DiaryManager.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/08/28.
//

protocol DiaryManagerDelegate {
    func showErrorAlert(error: Error)
}

struct DiaryManager {
    private(set) var diaryList: [Diary] = []
    private(set) var currentDiary: Diary?
    var delegate: DiaryManagerDelegate?
    var diaryPersistentManager: DiaryPersistentManager
    
    // MARK: DiaryEntity
    mutating func fetchDiaryList() {
        do {
            let diaryEntities = try diaryPersistentManager.fetch()
            diaryList = diaryEntities.map { diaryEntity in
                guard let title = diaryEntity.title,
                      let body = diaryEntity.body,
                      let createdDate = diaryEntity.createdDate else {
                    return Diary(title: NameSpace.empty, body: NameSpace.empty, createdDate: NameSpace.empty)
                }
                return Diary(title: title, body: body, createdDate: createdDate)
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
    
    // MARK: Diary
    mutating func fetchCurrentDiary(_ diary: Diary) {
        currentDiary = diary
    }

    func newDiary() -> Diary {
        let dateManager = DateManager()
        let diary = Diary(
            title: NameSpace.empty,
            body: NameSpace.empty,
            createdDate: dateManager.todayString()
        )
        
        return diary
    }
}

extension DiaryManager {
    private enum NameSpace {
        static let empty = ""
    }
}
