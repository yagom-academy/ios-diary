//
//  DiaryDetailViewControllerUseCase.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/09/12.
//

struct DiaryDetailViewControllerUseCase {
    private(set) var diary: Diary
    var diaryContentManager = DiaryContentManager()
    
    mutating func updateDiary(_ text: String) {
        diary = diaryContentManager.convert(with: text, diary)
    }
    
    func readDiary() -> String {
        return diaryContentManager.convert(with: diary)
    }
}
