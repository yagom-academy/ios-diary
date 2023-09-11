//
//  DiaryPersistentManager.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/09/11.
//

import CoreData

final class DiaryPersistentManager {
    lazy var diaryPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unable to load persistent stores: (error)")
            }
        }
        
        return container
    }()
    
    lazy var context = diaryPersistentContainer.viewContext
    
    func saveContext() throws {
        try context.save()
    }
    
    func fetch() throws -> [DiaryEntity] {
        let request = DiaryEntity.fetchRequest()
        let fetchResult = try context.fetch(request)
        
        return fetchResult
    }
    
    func insert(diary: Diary) throws {
        let entity = DiaryEntity(context: context)
        entity.identifier = diary.identifier
        entity.body = diary.body
        entity.title = diary.title
        entity.createdDate = diary.createdDate
        
        try saveContext()
    }
    
    func update(diary: Diary) throws {
        let request = DiaryEntity.fetchRequest()
        let fetchResults = try context.fetch(request)
        
        guard let result = fetchResults.filter({ $0.identifier == diary.identifier }).first else {
            return
        }
       
        result.title = diary.title
        result.body = diary.body
        
        try saveContext()
    }
    
    func delete(object: NSManagedObject) throws {
        context.delete(object)
        
        try context.save()
    }
    
    func deleteAll() throws {
        let fetchResults = try fetch()
        
        for result in fetchResults {
            context.delete(result)
        }
        
        try saveContext()
    }
    
    func isExist(_ diary: Diary) throws -> Bool {
        let fetchResults = try fetch()
        guard let result = fetchResults.filter({ $0.identifier == diary.identifier }).first else {
            return false
        }
        return true
    }
}
