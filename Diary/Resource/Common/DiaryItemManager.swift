//
//  DiaryItemManager.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/28.
//

import Foundation

final class DiaryItemManager {
    static let shared = DiaryItemManager()
    private var diaryItem: DiaryModel?
    
    func saveDiaryWith(title: String, body: String) {
        updateDiaryTo(title: title, body: body)
        
        if CoreDataManager.shared.fetchDiary(with: diaryItem?.id) == nil {
            generateDiary()
            
            if diaryItem?.title == Namespace.emptyString,
               diaryItem?.body == Namespace.emptyString { return }
            
            CoreDataManager.shared.insertDiary(diaryItem)
            let id = CoreDataManager.shared.fetchID(of: diaryItem)
            diaryItem?.id = id
        } else {
            CoreDataManager.shared.updateDiary(diaryItem)
        }
    }
    
    private func generateDiary() {
        diaryItem = DiaryModel(title: Namespace.emptyString,
                               body: Namespace.emptyString,
                               createdAt: Date())
    }
    
    private func updateDiaryTo(title: String, body: String) {
        diaryItem?.title = title
        diaryItem?.body = body
        diaryItem?.createdAt = Date()
    }
    
    func fetchDiary(data: DiaryModel) {
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
    
    func deleteDiary(data: DiaryModel?) {
        CoreDataManager.shared.deleteDiary(with: data?.id)
        diaryItem = nil
    }
}
