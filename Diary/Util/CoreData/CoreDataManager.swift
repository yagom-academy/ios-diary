//
//  CoreDataManager.swift
//  Diary
//
//  Created by rilla, songjun on 2023/05/02.
//

import Foundation
import CoreData

final class CoreDataManager {
    private enum DiaryKey {
        static let DataModel = "DiaryDataModel"
        static let EntityName = "DiaryEntity"
        static let title = "title"
        static let body = "body"
        static let timeIntervalSince1970 = "timeIntervalSince1970"
        static let id = "id"
    }
    
    static let shared = CoreDataManager()
    
    private init() { }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: DiaryKey.DataModel)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - Create
    func create(_ diary: Diary) {
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: DiaryKey.EntityName, in: context)
        
        if let entity = entity {
            let NSDiary = NSManagedObject(entity: entity, insertInto: context)
            NSDiary.setValue(diary.title, forKey: DiaryKey.title)
            NSDiary.setValue(diary.body, forKey: DiaryKey.body)
            NSDiary.setValue(diary.timeIntervalSince1970, forKey: DiaryKey.timeIntervalSince1970)
            NSDiary.setValue(diary.id, forKey: DiaryKey.id)
        }
        
        do {
          try context.save()
        } catch {
          print(error.localizedDescription)
        }
    }
    
    // MARK: - Read
    func fetch() -> [Diary]? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: DiaryKey.EntityName)
        
        do {
            let result = try context.fetch(fetchRequest) as? [Diary]
            return result
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    // MARK: - Update
    func update(_ diary: Diary) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: DiaryKey.EntityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", diary.id as CVarArg)
        
        do {
            let test = try context.fetch(fetchRequest)
            let objectUpdate = test[0] as! NSManagedObject
            
            objectUpdate.setValue(diary.title, forKey: "title")
            objectUpdate.setValue(diary.body, forKey: "body")
            objectUpdate.setValue(diary.timeIntervalSince1970, forKey: "timeIntervalSince1970")
            
            do {
                try context.save()
            } catch {
                print(error)
            }
        } catch { print(error) }
    }
}
