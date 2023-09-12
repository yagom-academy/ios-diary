//
//  CoreDataDiaryStorage.swift
//  Diary
//
//  Created by Erick on 2023/09/04.
//

import UIKit
import CoreData

final class CoreDataDiaryManager {
    
    // MARK: - Private Property
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: NameSpace.diary)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Save Context
    private func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}

// MARK: - Read Diary
extension CoreDataDiaryManager: DiaryReadable {
    
    func diaryEntrys() throws -> [DiaryEntry] {
        let diaryEntitys = try context.fetch(DiaryEntity.fetchRequest())
        let diaryEntrys = diaryEntitys.map {
            $0.diaryEntry()
        }
        
        return diaryEntrys
    }
}

// MARK: - Manage Diary
extension CoreDataDiaryManager: DiaryManageable {
    
    func storeDiary(title: String, body: String?) throws {
        let diaryEntity = DiaryEntity(context: context)
        diaryEntity.id = UUID()
        diaryEntity.title = title
        diaryEntity.body = body
        diaryEntity.creationDate = Date()
        
        try saveContext()
    }
    
    func updateDiary(_ diary: DiaryEntry) throws {
        let fetchRequest = DiaryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: NameSpace.idEqualFormat, diary.id.uuidString)
        
        if let diaryEntity = try context.fetch(fetchRequest).first {
            diaryEntity.title = diary.title
            diaryEntity.body = diary.body
            
            try saveContext()
        }
    }
    
    func storeDiary(_ diary: DiaryEntry) throws {
        let fetchRequest = DiaryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: NameSpace.idEqualFormat, diary.id.uuidString)
        
        if let diaryEntity = try context.fetch(fetchRequest).first {
            diaryEntity.title = diary.title
            diaryEntity.body = diary.body
        } else {
            let diaryEntity = DiaryEntity(context: context)
            diaryEntity.id = diary.id
            diaryEntity.title = diary.title
            diaryEntity.body = diary.body
            diaryEntity.creationDate = Date()
        }
        
        try saveContext()
    }
    
    func deleteDiary(_ diary: DiaryEntry) throws {
        let fetchRequest = DiaryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: NameSpace.idEqualFormat, diary.id.uuidString)
        
        if let diaryEntity = try context.fetch(fetchRequest).first {
            context.delete(diaryEntity)
            try saveContext()
        }
    }
    
    func deleteAll() throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: NameSpace.diaryEntity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try context.execute(deleteRequest)
    }
}

extension CoreDataDiaryManager {
    private enum NameSpace {
        static let diary = "DiaryData"
        static let diaryEntity = "DiaryEntity"
        static let idEqualFormat = "id == %@"
    }
}
