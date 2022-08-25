//
//  CoreDataManager.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/23.
//

import UIKit
import CoreData

class CoreDataManager: DataManagable {
    typealias Model = Diary
    
    private let persistentContainer: NSPersistentContainer = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return NSPersistentContainer() }
        let container = appDelegate.persistentContainer
        
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
    init() {
        NotificationCenter.default.post(name: .didReceiveData,
                                                    object: self)
    }

    func create(model: Diary) {
        let diaryEntity = DiaryEntity(context: context)
        diaryEntity.setValue(model.title, forKey: "title")
        diaryEntity.setValue(model.body, forKey: "body")
        diaryEntity.setValue(model.createdAt, forKey: "createdAt")
        diaryEntity.setValue(model.uuid, forKey: "uuid")
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    func fetch() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DiaryEntity")
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        guard let result = try? context.fetch(fetchRequest) else { return [] }
        
        return result
    }
    
    func update(model: Diary) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "DiaryEntity")
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", model.uuid.uuidString)
        
        do {
            guard let diaryEntity = try context.fetch(fetchRequest).last as? DiaryEntity else { return }
            
            diaryEntity.setValue(model.title, forKey: "title")
            diaryEntity.setValue(model.body, forKey: "body")
            diaryEntity.setValue(model.createdAt, forKey: "createdAt")
            diaryEntity.setValue(model.uuid, forKey: "uuid")
            
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func delete(_ id: UUID) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "DiaryEntity")
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", id as CVarArg)
        
        do {
            let requestResult = try context.fetch(fetchRequest)
            guard let objectToDelete = requestResult as? [NSManagedObject] else { return }
            
            for object in objectToDelete {
                context.delete(object)
            }
            
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func deleteAll() {
        let diarys = fetch()
        diarys.forEach { context.delete($0) }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}

