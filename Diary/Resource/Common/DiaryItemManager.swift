//
//  DiaryItemManager.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/28.
//

import Foundation

struct DiaryItemManager {
    var diaryItem: DiaryModel?
    
    mutating func saveDiaryWith(title: String, body: String) {
        updateDiaryWith(title: title, body: body)
        
        if CoreDataStack.shared.fetchDiary(with: diaryItem?.id) == nil {
            generateDiary()
            CoreDataStack.shared.insertDiary(diaryItem)
        } else {
            CoreDataStack.shared.updateDiary(diaryItem)
        }
    }
    
    mutating func generateDiary() {
        diaryItem = DiaryModel(id: UUID(),
                               title: "제목 없음",
                               body: "",
                               createdAt: Date())
    }
    
    mutating func updateDiaryWith(title: String, body: String) {
        diaryItem?.title = title
        diaryItem?.body = body
        diaryItem?.createdAt = Date()
    }
}
