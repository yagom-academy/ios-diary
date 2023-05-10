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
        static let iconData = "iconData"
    }
    
    static let shared = CoreDataManager()
    
    private init() { }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: DiaryKey.DataModel)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    private func saveContext() {
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
    
    // MARK: - CRUD
    func create(_ diary: Diary) {
        let context = persistentContainer.viewContext
        let storage = DiaryEntity(context: context)
        
        setNSDiaryValue(for: diary, at: storage)
        saveContext()
    }
    
    func update(_ diary: Diary) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: DiaryKey.EntityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", diary.id as CVarArg)
        
        do {
            let test = try context.fetch(fetchRequest)
            let objectUpdate = test[0] as? NSManagedObject
            
            setNSDiaryValue(for: diary, at: objectUpdate)
            saveContext()
        } catch {
            print(error)
        }
    }
    
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
    
    func delete(id: UUID) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: DiaryKey.EntityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let fetchedObject = try context.fetch(fetchRequest)
            guard let objectToDelete = fetchedObject[safe: 0] as? NSManagedObject else { return }
            context.delete(objectToDelete)
            
            saveContext()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Methods
    func search(id: UUID) -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: DiaryKey.EntityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        guard let fetchedObject = try? context.fetch(fetchRequest) else { return false }
        let result = fetchedObject.first != nil ? true : false
        
        return result
    }
    
    private func setNSDiaryValue(for diary: Diary, at NSDiary: NSManagedObject?) {
        NSDiary?.setValue(diary.title, forKey: DiaryKey.title)
        NSDiary?.setValue(diary.body, forKey: DiaryKey.body)
        NSDiary?.setValue(diary.timeIntervalSince1970, forKey: DiaryKey.timeIntervalSince1970)
        NSDiary?.setValue(diary.id, forKey: DiaryKey.id)
        NSDiary?.setValue(diary.iconData, forKey: DiaryKey.iconData)
    }
    
    private func convertToDiaryModel(for entities: [DiaryEntity]) -> [Diary] {
        let diaries = entities.map { entity in
            Diary(id: entity.id,
                  title: entity.title ?? "",
                  body: entity.body ?? "",
                  timeIntervalSince1970: Int(entity.timeIntervalSince1970),
                  iconData: entity.iconData
            )
        }
        
        return diaries
    }
}
