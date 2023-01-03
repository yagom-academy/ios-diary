//
//  DiaryItemManager.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/28.
//

import Foundation
import CoreData

final class DiaryItemManager {
    private var objectID: NSManagedObjectID?
    
    func create() throws -> DiaryModel {
        let id = UUID()
        try CoreDataManager.shared.insert(with: id)
        objectID = CoreDataManager.shared.fetchObjectID(with: id)
        return DiaryModel(id: id, title: Namespace.empty, body: Namespace.empty, createdAt: Date())
    }
    
    func update(title: String?, body: String?) throws {
        if isTitleValid(title) || isBodyValid(body) { return }
        try CoreDataManager.shared.update(objectID: objectID, title: title, body: body)
    }
    
    func validate(title: String?, body: String?) {
        if isTitleValid(title) && isBodyValid(body) == false {
            do {
                try deleteDiary()
            } catch {
                return
            }
            return
        }
        do {
            try CoreDataManager.shared.update(objectID: objectID, title: title, body: body)
        } catch {
            return
        }
    }
    
    private func isTitleValid(_ title: String?) -> Bool {
        return title != Placeholder.title && title != Namespace.empty
    }
    
    private func isBodyValid(_ body: String?) -> Bool {
        return body != Placeholder.body && body != Namespace.empty
    }
    
    func createDiaryShareForm() -> String {
        let entity = CoreDataManager.shared.fetch(with: objectID)
        
        let form: String = """
            title: \(entity?.title ?? Namespace.empty)
            body: \(entity?.body ?? Namespace.empty)
            created at: \(entity?.createdAt ?? Date())
            """

        return form
    }
    
    func fetchAllDiaries() throws -> [DiaryModel] {
        var diaryItems: [DiaryModel] = []
        let fetchedResults = try CoreDataManager.shared.fetchAllEntities()
        
        for result in fetchedResults {
            let diary = DiaryModel(id: result.id ?? UUID(),
                                   title: result.title ?? Namespace.empty,
                                   body: result.body ?? Namespace.empty,
                                   createdAt: result.createdAt ?? Date())
            diaryItems.append(diary)
        }
        
        return diaryItems
    }
    
    func deleteDiary() throws {
        try CoreDataManager.shared.delete(with: objectID)
    }
}
