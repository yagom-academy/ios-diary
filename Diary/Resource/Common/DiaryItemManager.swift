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
            
            if diaryItem?.title == "",
               diaryItem?.body == "" { return }
            
            CoreDataStack.shared.insertDiary(diaryItem)
        } else {
            CoreDataStack.shared.updateDiary(diaryItem)
        }
    }
    
    mutating func generateDiary() {
        diaryItem = DiaryModel(id: UUID(),
                               title: "",
                               body: "",
                               createdAt: Date())
    }
    
    mutating func updateDiaryWith(title: String, body: String) {
        diaryItem?.title = title
        diaryItem?.body = body
        diaryItem?.createdAt = Date()
    }
    
    mutating func fetchDiary(data: DiaryModel) {
        diaryItem = data
    }
    
    func createDiaryShareForm() -> String {
        guard let diaryItem = diaryItem else { return "" }
        
        let form: String = """
            id: \(diaryItem.id)
            title: \(diaryItem.title)
            body: \(diaryItem.body)
            created at: \(diaryItem.createdAt)
            """

        return form
    }
    
    mutating func deleteDiary() {
        CoreDataStack.shared.deleteDiary(with: diaryItem?.id)
        diaryItem = nil
    }
}
