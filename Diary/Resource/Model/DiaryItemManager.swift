//
//  DiaryItemManager.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/28.
//

import Foundation

final class DiaryItemManager {
    static let shared = DiaryItemManager()
    private init() { }
    
    func create() throws -> DiaryModel {
        let date = Date()
        try CoreDataManager.shared.insert(date: date)
        let id = CoreDataManager.shared.fetchID(date: date)
        return DiaryModel(id: id, title: Namespace.empty, body: Namespace.empty, createdAt: date)
    }
    
    func update(diaryItem: DiaryModel?) throws {
        if isValid(diaryItem) == false { return }
        try CoreDataManager.shared.update(diaryItem)
    }
    
    func validate(diaryItem: DiaryModel?) {
        if isValid(diaryItem) == false {
            do {
                try deleteDiary(data: diaryItem)
            } catch {
                return
            }
            return
        }
        do {
            try CoreDataManager.shared.update(diaryItem)
        } catch {
            return
        }
    }
    
    private func isValid(_ diaryItem: DiaryModel?) -> Bool {
        return isTitleValid(diaryItem?.title) && isBodyValid(diaryItem?.body)
    }
    
    private func isTitleValid(_ title: String?) -> Bool {
        return title != Placeholder.title && title != Namespace.empty
    }
    
    private func isBodyValid(_ body: String?) -> Bool {
        return body != Placeholder.body && body != Namespace.empty
    }
    
    func createDiaryShareForm(diaryItem: DiaryModel?) -> String {
        guard let diaryItem = diaryItem else { return Namespace.empty }
        
        let form: String = """
            title: \(diaryItem.title)
            body: \(diaryItem.body)
            created at: \(diaryItem.createdAt)
            """

        return form
    }
    
    func fetchAllDiaries() throws -> [DiaryModel] {
        var diaryItems: [DiaryModel] = []
        let fetchedResults = try CoreDataManager.shared.fetchAllEntities()
        
        for result in fetchedResults {
            let diary = DiaryModel(id: result.objectID,
                                   title: result.title ?? Namespace.empty,
                                   body: result.body ?? Namespace.empty,
                                   createdAt: result.createdAt ?? Date())
            diaryItems.append(diary)
        }
        
        return diaryItems
    }
    
    func deleteDiary(data: DiaryModel?) throws {
        try CoreDataManager.shared.delete(with: data?.id)
    }
}
