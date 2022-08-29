//
//  CoreDataManager.swift
//  CoreDataFramework
//
//  Created by 백곰, 주디 on 2022/08/25.
//

import Foundation
import CoreData

public struct SampleModel {
    let entityName: String
    let sampleData: [String: Any]
    
    public init(entityName: String, sampleData: [String: Any]) {
        self.entityName = entityName
        self.sampleData = sampleData
    }
}

public class CoreDataManager {
    public static let shared = CoreDataManager()
    private init() { }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    public func fetchDiary() -> [DiaryEntity]? {
        do {
            let diary = try persistentContainer.viewContext.fetch(DiaryEntity.fetchRequest())
            return diary
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    private func saveContext () {
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
    
    private func updateDiary(id: UUID, title: String, body: String, createdAt: Double, with diaryEntity: DiaryEntity) {
        diaryEntity.setValue(title, forKey: "title")
        diaryEntity.setValue(body, forKey: "body")
        diaryEntity.setValue(createdAt, forKey: "createdAt")
        diaryEntity.setValue(id, forKey: "id")
        
        saveContext()
    }
    
    public func saveDiary(id: UUID, title: String, body: String, createdAt: Double) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "DiaryEntity")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            guard let diaryUpdate = try context.fetch(fetchRequest).last as? DiaryEntity else {
                let diaryEntity = DiaryEntity(context: context)
                updateDiary(id: id, title: title, body: body, createdAt: createdAt, with: diaryEntity)
                return
            }
            
            updateDiary(id: id, title: title, body: body, createdAt: createdAt, with: diaryUpdate)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func deleteDiary(id: UUID) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "DiaryEntity")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            guard let diaryDelete = try context.fetch(fetchRequest).last as? NSManagedObject else { return }
            context.delete(diaryDelete)
        } catch {
            print(error.localizedDescription)
        }
        
        saveContext()
    }
    
    public func fetch<T>(_ request: NSFetchRequest<T>) -> [T]? {
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            return result
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    public func save(sample: SampleModel) {
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: sample.entityName, into: context)
        
        entity.setValuesForKeys(sample.sampleData)
        
//        for data in sample.sampleData {
//                    entity.setValue(data.value, forKey: data.key)
//        }
//
        saveContext()
    }
    
    public func update(_ object: NSManagedObject) {
        do {
            try object.managedObjectContext?.save()
        } catch {
            print(error.localizedDescription)
        }
        saveContext()
    }
    
    public func delete(_ object: NSManagedObject) throws {
        let context = persistentContainer.viewContext
        context.delete(object)
        
        saveContext()
    }
}
