//
//  PersistenceManager.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/17.
//

import Foundation
import CoreData

fileprivate extension AppConstants {
    static let titleKeyName = "title"
    static let bodyKeyName = "body"
    static let createdAtKeyName = "createdAt"
    static let idKeyName = "id"
}

final class PersistenceManager {
    static let shared = PersistenceManager()
    private init() {}
    
    enum Method {
        case create(diary: Diary)
        case read
        case update(diary: Diary)
        case delete(_ objectToDelete: DiaryEntity, index: Int? = nil)
    }
    
    private var diaryEntities = [DiaryEntity]()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: AppConstants.entityName)
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError()
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private var entity: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: AppConstants.entityName, in: context)
    }
    
    func diaries() -> [DiaryEntity] {
        return diaryEntities
    }
}

extension PersistenceManager {
    func execute(by method: Method) {
        switch method {
        case .create(let diary):
            createData(by: diary)
        case .read:
            fetchData()
        case .update(let diary):
            updateData(by: diary)
        case .delete(let objectToDelete, let index):
            deleteData(by: objectToDelete, index: index)
        }
    }

    private func createData(by diary: Diary) {
        let request: NSFetchRequest<DiaryEntity> = DiaryEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", diary.id)
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        
        let fetchResult = try? context.fetch(request)
        guard fetchResult?.first == nil else {
            return
        }
        
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            managedObject.setValue(diary.title, forKey: AppConstants.titleKeyName)
            managedObject.setValue(diary.body, forKey: AppConstants.bodyKeyName)
            managedObject.setValue(diary.createdAt, forKey: AppConstants.createdAtKeyName)
            managedObject.setValue(diary.id, forKey: AppConstants.idKeyName)
            saveToContext()
        }
    }
    
    private func fetchData() {
        do {
            let request = DiaryEntity.fetchRequest()
            request.returnsObjectsAsFaults = false
            let fetchResult = try context.fetch(request)
            diaryEntities = fetchResult.reversed()
        } catch {
            print(error.localizedDescription)
        }
    }
        
    private func updateData(by diary: Diary) {
        let request: NSFetchRequest<DiaryEntity> = DiaryEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", diary.id)
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        
        let fetchResult = try? context.fetch(request)
        guard let diaryToUpdate = fetchResult?.first else {
            return
        }
        
        diaryToUpdate.setValue(diary.title, forKey: AppConstants.titleKeyName)
        diaryToUpdate.setValue(diary.body, forKey: AppConstants.bodyKeyName)
        diaryToUpdate.setValue(diary.createdAt, forKey: AppConstants.createdAtKeyName)
        diaryToUpdate.setValue(diary.id, forKey: AppConstants.idKeyName)
        saveToContext()
    }
    
    private func deleteData(by object: DiaryEntity, index: Int? = nil) {
        if let index = index {
            diaryEntities.remove(at: index)
        }
        
        context.delete(object)
        saveToContext()
    }
    
    private func saveToContext() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
