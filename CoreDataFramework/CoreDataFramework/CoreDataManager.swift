//
//  CoreDataManager.swift
//  CoreDataFramework
//
//  Created by 백곰, 주디 on 2022/08/25.
//

import Foundation
import CoreData

public class CoreDataManager {
    public static let shared = CoreDataManager()
    private let identifier: String = "yagom.net.CoreDataFramework"
    private let model: String = "Diary"
    
    private init() { }
        
    private lazy var persistentContainer: NSPersistentContainer = {
        let bundle = Bundle(identifier: identifier)
        guard let modelURL = bundle?.url(forResource: model, withExtension: "momd") else { fatalError("invalid URL") }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else { fatalError("invalid NSManagedObjectModel") }
        
         let container = NSPersistentContainer(name: model, managedObjectModel: managedObjectModel)
        container.loadPersistentStores(completionHandler: { (_, error) in
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
    
    public func fetchDiary() -> [DiaryEntity]? {
        do {
            let diary = try persistentContainer.viewContext.fetch(DiaryEntity.fetchRequest())
            return diary
        } catch {
            print(error.localizedDescription)
        }
        return nil
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
}
