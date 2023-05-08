//
//  DiaryService.swift
//  Diary
//
//  Created by Andrew, brody on 2023/05/01.
//

import Foundation
import CoreData

final class DiaryService {
    let coreDataStack: CoreDataManagable
    let managedContext = CoreDataManager.shared.managedContext
    let entityName = "Diary"
    
    init(coreDataStack: CoreDataManagable) {
        self.coreDataStack = coreDataStack
    }
}

extension DiaryService {
    @discardableResult
    func create(id: UUID, title: String, body: String) -> Result<Diary, CoreDataError> {
        let diary = Diary(context: managedContext)
        diary.id = id
        diary.title = title
        diary.body = body
        diary.createdAt = Date()
        
        let result = CoreDataManager.shared.saveContext()
        
        if result {
            return .success(diary)
        } else {
            print(CoreDataError.insertError.localizedDescription)
            return .failure(CoreDataError.insertError)
        }
    }
    
    @discardableResult
    func update(id: UUID, title: String, body: String) -> Result<Diary, CoreDataError> {
        var targetData: Diary?
        do {
            let filteredRequest = Diary.fetchRequest()
            filteredRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
            targetData = try self.managedContext.fetch(filteredRequest).first
        } catch {
            return .failure(CoreDataError.fetchError)
        }
        
        guard let targetData else {
            return .failure(CoreDataError.fetchError)
        }
        
        targetData.body = body
        targetData.title = title
        targetData.createdAt = Date()
        
        let result = CoreDataManager.shared.saveContext()
        
        if result {
            return .success(targetData)
        } else {
            print(CoreDataError.updateError.localizedDescription)
            return .failure(CoreDataError.updateError)
        }
    }
    
    @discardableResult
    func delete(id: UUID) -> Result<Bool, CoreDataError> {
        var targetData: Diary?
        do {
            let filteredRequest = Diary.fetchRequest()
            filteredRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
            targetData = try self.managedContext.fetch(filteredRequest).first
        } catch {
            return .failure(CoreDataError.fetchError)
        }
        
        guard let targetData else {
            return .failure(CoreDataError.fetchError)
        }
        
        managedContext.delete(targetData)
        
        let result = CoreDataManager.shared.saveContext()
        
        if result {
            return .success(true)
        } else {
            print(CoreDataError.deleteError.localizedDescription)
            return .failure(CoreDataError.deleteError)
        }
    }
}
