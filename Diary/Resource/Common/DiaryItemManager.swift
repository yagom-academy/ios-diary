//
//  DiaryItemManager.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/28.
//

import Foundation

struct DiaryItemManager {
    private var diaryItem: DiaryModel?
    
    mutating func saveDiaryWith(title: String, body: String) {
        updateDiaryWith(title: title, body: body)
        
        if CoreDataStack.shared.fetchDiary(with: diaryItem?.id) == nil {
            generateDiary()
            
            if diaryItem?.title == Namespace.emptyString,
               diaryItem?.body == Namespace.emptyString { return }
            
            CoreDataStack.shared.insertDiary(diaryItem)
            let id = CoreDataStack.shared.fetchID(of: diaryItem)
            diaryItem?.id = id
        } else {
            CoreDataStack.shared.updateDiary(diaryItem)
        }
    }
    
    mutating func generateDiary() {
        diaryItem = DiaryModel(title: Namespace.emptyString,
                               body: Namespace.emptyString,
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

    func returnDiaryItem() -> DiaryModel? {
        return diaryItem
    }
    
    func createDiaryShareForm() -> String {
        guard let diaryItem = diaryItem else { return Namespace.emptyString }
        
        let form: String = """
            title: \(diaryItem.title)
            body: \(diaryItem.body)
            created at: \(diaryItem.createdAt)
            """

        return form
    }
    
    mutating func deleteDiary(data: DiaryModel?) {
        CoreDataStack.shared.deleteDiary(with: data?.id)
        diaryItem = nil
    }
}
