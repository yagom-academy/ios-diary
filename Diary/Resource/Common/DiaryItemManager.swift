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
        if CoreDataManager.shared.fetchDiary(with: diaryItem?.id) == nil {
            generateDiary()
            updateDiaryTo(title: title, body: body)
            
            if !validate(diaryItem: diaryItem) { return }
            
            CoreDataManager.shared.insertDiary(diaryItem)
            let id = CoreDataManager.shared.fetchID(of: diaryItem)
            diaryItem?.id = id
        } else {
            updateDiaryTo(title: title, body: body)
            CoreDataManager.shared.updateDiary(diaryItem)
        }
    }
    
    private func generateDiary() {
        diaryItem = DiaryModel(title: Namespace.empty,
                               body: Namespace.empty,
                               createdAt: Date())
    }
    
    private func updateDiaryTo(title: String, body: String) {
        diaryItem?.title = title
        diaryItem?.body = body
    }
    
    private func validate(diaryItem: DiaryModel?) -> Bool {
        if diaryItem?.title == Placeholder.title, diaryItem?.body == Namespace.empty { return false }
        else if diaryItem?.title == Namespace.empty, diaryItem?.body == Placeholder.body { return false }
        else if diaryItem?.title == Placeholder.title, diaryItem?.body == Placeholder.body { return false }
        else { return true }
    }
    
    func fetchDiary(data: DiaryModel) {
        diaryItem = data
    }
    
    func returnDiaryItem() -> DiaryModel? {
        return diaryItem
    }
    
    func createDiaryShareForm() -> String {
        guard let diaryItem = diaryItem else { return Namespace.empty }
        
        let form: String = """
            title: \(diaryItem.title)
            body: \(diaryItem.body)
            created at: \(diaryItem.createdAt)
            """

        return form
    }
    
    func deleteDiary(data: DiaryModel?) {
        CoreDataManager.shared.deleteDiary(with: data?.id)
        resetDiaryItem()
    }
    
    func resetDiaryItem() {
        diaryItem = nil
    }
}
