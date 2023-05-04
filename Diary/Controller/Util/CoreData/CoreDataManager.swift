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
        container.loadPersistentStores(completionHandler: { storeDescription, error in
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
        guard let entity = NSEntityDescription.entity(forEntityName: DiaryKey.EntityName, in: context) else { return }
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: DiaryKey.EntityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", diary.id as CVarArg)
        
        let fetchedObject = try? context.fetch(fetchRequest)[safe: 0] as? NSManagedObject ?? NSManagedObject(entity: entity, insertInto: context)
        
        setNSDiaryValue(for: diary, at: fetchedObject)
        
        do {
            try context.save()
            
        } catch { print(error) }
    }
    
    private func setNSDiaryValue(for diary: Diary, at NSDiary: NSManagedObject?) {
        NSDiary?.setValue(diary.title, forKey: DiaryKey.title)
        NSDiary?.setValue(diary.body, forKey: DiaryKey.body)
        NSDiary?.setValue(diary.timeIntervalSince1970, forKey: DiaryKey.timeIntervalSince1970)
        NSDiary?.setValue(diary.id, forKey: DiaryKey.id)
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
    func delete(id: UUID) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: DiaryKey.EntityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let fetchedObject = try context.fetch(fetchRequest)
            guard let objectToDelete = fetchedObject[safe: 0] as? NSManagedObject else { return }
            context.delete(objectToDelete)
            
            try context.save()
            
        } catch {
            print(error)
        }
    }
}
