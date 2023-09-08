//
//  CoreDataDiaryStorage.swift
//  Diary
//
//  Created by Erick on 2023/09/04.
//

import UIKit
import CoreData

final class CoreDataDiaryStorage: DiaryStorageProtocol {
    
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
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data CRUD
    func diaryEntrys() throws -> [DiaryEntry] {
        if let diaryEntitys = try context.fetch(DiaryEntity.fetchRequest()) as? [DiaryEntity] {
            let diaryEntrys = try diaryEntitys.map {
                try $0.diaryEntry()
            }
            
            return diaryEntrys
        } else {
            throw StorageError.loadDataFailed
        }
    }
    
    func storeDiary(_ diary: DiaryEntry) throws {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: NameSpace.diaryEntity, in: context),
              let creationDate = DateFormatManager.timestamp(localeDateFormatter: UserDateFormatter.shared, string: diary.creationDate) else {
            throw StorageError.storeDataFailed
        }
        
        let diaryEntity = NSManagedObject(entity: entityDescription, insertInto: context)
        diaryEntity.setValue(diary.id, forKey: NameSpace.id)
        diaryEntity.setValue(diary.title, forKey: NameSpace.title)
        diaryEntity.setValue(diary.body, forKey: NameSpace.body)
        diaryEntity.setValue(creationDate, forKey: NameSpace.creationDate)
        
        try context.save()
    }
    
    func updateDiary(_ diary: DiaryEntry) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: NameSpace.diaryEntity)
        fetchRequest.predicate = NSPredicate(format: NameSpace.idEqualFormat, diary.id.uuidString)
        
        if let diaryEntity = try context.fetch(fetchRequest).first as? NSManagedObject,
           let creationDate = DateFormatManager.timestamp(localeDateFormatter: UserDateFormatter.shared, string: diary.creationDate) {
            
            diaryEntity.setValue(diary.title, forKey: NameSpace.title)
            diaryEntity.setValue(diary.body, forKey: NameSpace.body)
            diaryEntity.setValue(creationDate, forKey: NameSpace.creationDate)
            
            try context.save()
        } else {
            throw StorageError.updateDataFailed
        }
    }
    
    func deleteDiary(_ diary: DiaryEntry) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: NameSpace.diaryEntity)
        fetchRequest.predicate = NSPredicate(format: NameSpace.idEqualFormat, diary.id.uuidString)
        
        if let diaryEntity = try context.fetch(fetchRequest).first as? NSManagedObject {
            context.delete(diaryEntity)
            try context.save()
        } else {
            throw StorageError.deleteDataFailed
        }
    }
    
    func deleteAll() throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: NameSpace.diaryEntity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try context.execute(deleteRequest)
    }
}

extension CoreDataDiaryStorage {
    private enum NameSpace {
        static let diary = "Diary"
        static let diaryEntity = "DiaryEntity"
        static let id = "id"
        static let title = "title"
        static let body = "body"
        static let creationDate = "creationDate"
        static let idEqualFormat = "id == %@"
    }
}
