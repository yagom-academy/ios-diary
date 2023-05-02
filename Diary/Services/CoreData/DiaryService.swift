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
    
    public func add(title: String, body: String) -> Result<Bool ,CoreDataError> {
        let newDiary = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedContext)
        newDiary.setValue(title, forKey: "title")
        newDiary.setValue(body, forKey: "body")
        newDiary.setValue(UUID(), forKey: "id")
        newDiary.setValue(Date(), forKey: "createdAt")
        
        let result = CoreDataStack.shared.saveContext()
        
        return result == true ? .success(true) : .failure(CoreDataError.insertError)
    }
    
    public func update(id: UUID, title: String, body: String) -> Result<Bool, CoreDataError> {
        var targetData: Diary?
        do {
            let filteredRequest = Diary.fetchRequest()
            filteredRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
            targetData = try self.managedContext.fetch(filteredRequest).first
        } catch {
            return .failure(CoreDataError.fetchError)
        }
        
        targetData?.body = body
        targetData?.title = title
        targetData?.createdAt = Date()
        
        let result = CoreDataStack.shared.saveContext()
        
        return result == true ? .success(true) : .failure(CoreDataError.updateError)
    }
}
