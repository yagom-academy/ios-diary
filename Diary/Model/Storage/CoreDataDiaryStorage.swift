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
        let diaryEntitys = try context.fetch(DiaryEntity.fetchRequest())
        let diaryEntrys = try diaryEntitys.map {
            try $0.diaryEntry()
        }
        
        return diaryEntrys
    }
    
    func storeDiary(title: String, body: String?) {
        let diaryEntity = DiaryEntity(context: context)
        diaryEntity.id = UUID()
        diaryEntity.title = title
        diaryEntity.body = body
        diaryEntity.creationDate = Date()
        
        saveContext()
    }
    
    func updateDiary(_ diary: DiaryEntry) {
        let fetchRequest = DiaryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: NameSpace.idEqualFormat, diary.id.uuidString)
        
        if let diaryEntity = try? context.fetch(fetchRequest).first {
            diaryEntity.title = diary.title
            diaryEntity.body = diary.body
            
            saveContext()
        }
    }
    
    func deleteDiary(_ diary: DiaryEntry) {
        let fetchRequest = DiaryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: NameSpace.idEqualFormat, diary.id.uuidString)
        
        if let diaryEntity = try? context.fetch(fetchRequest).first {
            context.delete(diaryEntity)
            saveContext()
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
        static let diary = "DiaryData"
        static let diaryEntity = "DiaryEntity"
        static let idEqualFormat = "id == %@"
    }
}
