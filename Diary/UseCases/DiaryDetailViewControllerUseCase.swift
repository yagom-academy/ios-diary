//
//  DiaryDetailViewControllerUseCase.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/09/12.
//

protocol DiaryDetailViewControllerUseCaseDelegate: AnyObject {
    func showErrorAlert(error: Error)
}

struct DiaryDetailViewControllerUseCase {
    private(set) var diary: Diary
    weak var delegate: DiaryDetailViewControllerUseCaseDelegate?
    let diaryContentManager = DiaryContentManager()
    let diaryPersistentManager: DiaryPersistentManager
    
    mutating func updateDiary(_ text: String) {
        guard diaryContentManager.isDiaryTextEmpty(text) else {
            return
        }
        
        diary = diaryContentManager.convert(with: text, diary)
        
        upsert(diary)
    }
    
    func upsert(_ diary: Diary) {
        do {
            try diaryPersistentManager.upsert(diary)
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
    
    func readDiary() -> String {
        return diaryContentManager.convert(with: diary)
    }
}
