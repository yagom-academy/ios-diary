//
//  DiaryDetailViewControllerUseCase.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/09/12.
//

struct DiaryDetailViewControllerUseCase {
    private(set) var diary: Diary
    var diaryContentManager = DiaryContentManager()
    
    mutating func convert(_ text: String) {
        diary.title = diaryContentManager.convert(with: text).0
        diary.body = diaryContentManager.convert(with: text).1
    }
}
