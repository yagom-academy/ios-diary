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
    func diaryEntrys() throws -> [DiaryEntry] {
        guard let context,
              let diaryEntitys = try context.fetch(DiaryEntity.fetchRequest()) as? [DiaryEntity] else {
            throw StorageError.loadDataFailed
        }
        
        let diaryEntrys = try diaryEntitys.map {
            try $0.diaryEntry()
        }
        
        return diaryEntrys
    }
    
    func storeDiary(_ diary: DiaryEntry) throws {
        guard let context,
              let entity = NSEntityDescription.entity(forEntityName: "DiaryEntity", in: context),
              let creationDate = DateFormatManager.timestamp(localeDateFormatter: UserDateFormatter.shared, string: diary.creationDate) else {
            throw StorageError.saveDataFailed
        }
        
        let diaryEntity = NSManagedObject(entity: entity, insertInto: context)
        diaryEntity.setValue(diary.id, forKey: "id")
        diaryEntity.setValue(diary.title, forKey: "title")
        diaryEntity.setValue(diary.body, forKey: "body")
        diaryEntity.setValue(creationDate, forKey: "creationDate")
        
        try context.save()
    }
    
}
