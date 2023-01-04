//
//  DiaryItemManager.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/28.
//

import UIKit
import CoreData

final class DiaryItemManager {
    private var coreDataManager: CoreDataManageable?
    private var objectID: NSManagedObjectID?
    private var hasTitle: Bool = false
    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    func create() throws {
        let id = UUID()
        try coreDataManager?.insert(with: id)
        objectID = coreDataManager?.fetchObjectID(with: id)
    }
    
    func fetchID(id: UUID) {
        objectID = coreDataManager?.fetchObjectID(with: id)
    }
    
    func update(title: String?, body: String?) throws {
        if isTitleValid(title) || isBodyValid(body) {
            try coreDataManager?.update(objectID: objectID, title: title, body: body)
        }
    }
    
    func validate(title: String?, body: String?) throws {
        if isTitleValid(title) && isBodyValid(body) == false {
            try deleteDiary()
        } else {
            try coreDataManager?.update(objectID: objectID, title: title, body: body)
        }
    }
    
    private func isTitleValid(_ title: String?) -> Bool {
        return title != Placeholder.title && title != Namespace.empty
    }
    
    private func isBodyValid(_ body: String?) -> Bool {
        return body != Placeholder.body && body != Namespace.empty
    }
    
    func createDiaryShareForm() -> String {
        let entity = coreDataManager?.fetch(with: objectID)
        
        let form: String = """
            title: \(entity?.title ?? Namespace.empty)
            body: \(entity?.body ?? Namespace.empty)
            created at: \(entity?.createdAt ?? Date())
            """

        return form
    }
    
    func fetchAllDiaries() throws -> [DiaryModel] {
        var diaryItems: [DiaryModel] = []
        guard let fetchedResults = try coreDataManager?.fetchAllEntities() else { return diaryItems }
        
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
        try coreDataManager?.delete(with: objectID)
    }
    
    func isOversized(height: CGFloat, maxHeight: CGFloat) -> Bool {
        return height > maxHeight
    }
    
    func enter(from title: String) -> (trimmedTitle: String, hasTitle: Bool) {
        if !hasTitle,
           title.firstIndex(of: "\n") != nil {
            hasTitle = true
            return (title.trimmingCharacters(in: .whitespacesAndNewlines), hasTitle)
        }
        
        return (title, false)
    }
    
    func setPlaceholder(textView: UITextView, text: String) {
        if textView.text.isEmpty {
            textView.textColor = .systemGray3
            textView.text = text
        } else {
            textView.resignFirstResponder()
        }
    }
    
    func removePlaceholder(textView: UITextView) {
        let isPlaceholder: Bool = textView.textColor == .systemGray3
        
        if isPlaceholder {
            textView.text = nil
            textView.textColor = .black
        }
    }
}
