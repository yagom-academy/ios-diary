//
//  DiaryService.swift
//  Diary
//
//  Created by Andrew, brody on 2023/05/01.
//

import Foundation
import CoreData

public final class DiaryService {
    let coreDataStack: CoreDataStack
    let managedContext = CoreDataStack.shared.managedContext
    let entityName = "Diary"
    
    public init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
}

extension DiaryService {
    
    @discardableResult
    public func create(id: UUID, title: String, body: String) -> Result<Diary, CoreDataError> {
        let diary = Diary(context: managedContext)
        diary.id = id
        diary.title = title
        diary.body = body
        diary.createdAt = Date()
        
        let result = CoreDataStack.shared.saveContext()
        
        return result == true ? .success(diary) : .failure(CoreDataError.insertError)
    }
    
    @discardableResult
    public func update(id: UUID, title: String, body: String) -> Result<Diary, CoreDataError> {
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
        
        let result = CoreDataStack.shared.saveContext()
        
        return result == true ? .success(targetData) : .failure(CoreDataError.updateError)
    }
    
    @discardableResult
    public func delete(id: UUID) -> Result<Bool, CoreDataError> {
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
        
        let result = CoreDataStack.shared.saveContext()
        
        return result == true ? .success(true) : .failure(CoreDataError.deleteError)
    }
}
