//
//  DiaryDetailViewControllerUseCase.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/09/12.
//

protocol DiaryDetailViewControllerUseCaseDelegate: AnyObject {
    func upsert(_ diary: Diary)
}

struct DiaryDetailViewControllerUseCase {
    private(set) var diary: Diary
    weak var delegate: DiaryDetailViewControllerUseCaseDelegate?
    let diaryContentManager = DiaryContentManager()
    
    mutating func updateDiary(_ text: String) {
        guard text.isEmpty == false else {
            return
        }
        
        diary = diaryContentManager.convert(with: text, diary)
        
        delegate?.upsert(diary)
    }
    
    func readDiary() -> String {
        return diaryContentManager.convert(with: diary)
    }
}
