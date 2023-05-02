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

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: DiaryKey.DataModel)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private func saveContext () {
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
    
    // MARK: - Create & Update
    func register(_ diary: Diary) {
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: DiaryKey.EntityName, in: context)
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: DiaryKey.EntityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", diary.id as CVarArg)
        
        do {
            let fetchedObject = try context.fetch(fetchRequest)
            
            if fetchedObject.isEmpty {
                if let entity = entity {
                    let NSDiary = NSManagedObject(entity: entity, insertInto: context)
                    NSDiary.setValue(diary.title, forKey: DiaryKey.title)
                    NSDiary.setValue(diary.body, forKey: DiaryKey.body)
                    NSDiary.setValue(diary.timeIntervalSince1970, forKey: DiaryKey.timeIntervalSince1970)
                    NSDiary.setValue(diary.id, forKey: DiaryKey.id)
                }
                
            } else {
                
                let objectUpdate = fetchedObject[0] as! NSManagedObject
                
                objectUpdate.setValue(diary.title, forKey: "title")
                objectUpdate.setValue(diary.body, forKey: "body")
                objectUpdate.setValue(diary.timeIntervalSince1970, forKey: "timeIntervalSince1970")
   
            }
            
            do {
                try context.save()
            } catch {
                print(error)
            }
           
        } catch { print(error) }
    }
    
    // MARK: - Read
    func fetch() -> [Diary]? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<DiaryEntity>(entityName: DiaryKey.EntityName)
        
        do {
            let result = try context.fetch(fetchRequest)
            return convertToDiaryModel(for: result)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func convertToDiaryModel(for entities: [DiaryEntity]) -> [Diary] {
        let diaries = entities.map { entity in
            Diary(id: entity.id,
                  title: entity.title ?? "",
                  body: entity.body ?? "",
                  timeIntervalSince1970: Int(entity.timeIntervalSince1970))
        }
        
        return diaries
    }
    
    // MARK: - Delete
    func deleteData(id: UUID) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: DiaryKey.EntityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let fetchedObject = try context.fetch(fetchRequest)
            let objectToDelete = fetchedObject[0] as! NSManagedObject
            context.delete(objectToDelete)
            do {
                try context.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
}
