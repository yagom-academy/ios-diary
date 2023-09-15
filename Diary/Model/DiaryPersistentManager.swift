//
//  DiaryPersistentManager.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/09/11.
//

import CoreData

final class DiaryPersistentManager {
    private lazy var diaryPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unable to load persistent stores: (error)")
            }
        }
        
        return container
    }()
    private lazy var context = diaryPersistentContainer.viewContext
    
    func fetch() throws -> [DiaryEntity] {
        let request = DiaryEntity.fetchRequest()
        let fetchResult = try context.fetch(request)
        
        return fetchResult
    }
    
    func upsert(_ diary: Diary) throws {
        if try isExist(diary) {
            try update(diary)
        } else {
            try insert(diary)
        }
    }
    
    func delete(_ identifier: UUID) throws {
        let fetchResults = try fetch()
        
        guard let result = fetchResults.filter({ $0.identifier == identifier }).first else {
            throw CoreDataError.notFoundData
        }
        
        context.delete(result)
        try saveContext()
    }
    
    private func saveContext() throws {
        guard context.hasChanges else {
            return
        }
        
        try context.save()
    }
    
    private func insert(_ diary: Diary) throws {
        let entity = DiaryEntity(context: context)
        entity.identifier = diary.identifier
        entity.body = diary.body
        entity.title = diary.title
        entity.createdDate = diary.createdDate
        
        try saveContext()
    }
    
    private func update(_ diary: Diary) throws {
        let request = DiaryEntity.fetchRequest()
        let fetchResults = try context.fetch(request)
        
        guard let result = fetchResults.filter({ $0.identifier == diary.identifier }).first else {
            throw CoreDataError.notFoundData
        }
       
        result.title = diary.title
        result.body = diary.body
        
        try saveContext()
    }
    
    private func isExist(_ diary: Diary) throws -> Bool {
        let fetchResults = try fetch()
        
        if fetchResults.filter({ $0.identifier == diary.identifier }).first == nil {
            return false
        } else {
            return true
        }
    }
}
