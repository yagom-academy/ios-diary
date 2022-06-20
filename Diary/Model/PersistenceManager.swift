//
//  PersistenceManager.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/17.
//

import Foundation
import CoreData

enum Method {
    case create(diary: Diary)
    case read
    case update(diary: Diary)
    case delete(_ objectToDelete: DiaryEntity, index: Int? = nil)
}

final class PersistenceManager {
    static let shared = PersistenceManager()
    private init() { }
    
    private var diaryEntities = [DiaryEntity]()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DiaryEntity")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError()
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    private var entity: NSEntityDescription? {
        return  NSEntityDescription.entity(forEntityName: "DiaryEntity", in: context)
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

    private func createData(by data: Diary) {
        
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            managedObject.setValue(data.title, forKey: "title")
            managedObject.setValue(data.body, forKey: "body")
            managedObject.setValue(data.createdAt, forKey: "createdAt")
            managedObject.setValue(data.id, forKey: "id")
            
            saveToContext()
        }
    }
    
    private func fetchData() {
        do {
            let request = DiaryEntity.fetchRequest()
            request.returnsObjectsAsFaults = false
            let fetchResult = try self.context.fetch(request)
            diaryEntities = fetchResult
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func diaries() -> [DiaryEntity] {
        diaryEntities
    }
    
    private func updateData(by data: Diary) {
        let request: NSFetchRequest<DiaryEntity> = DiaryEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", data.id)
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        
        let fetchResult = try? context.fetch(request)
        guard let diaryToUpdate = fetchResult?.first else {
            return
        }
        
        diaryToUpdate.setValue(data.title, forKey: "title")
        diaryToUpdate.setValue(data.body, forKey: "body")
        diaryToUpdate.setValue(data.createdAt, forKey: "createdAt")
        diaryToUpdate.setValue(data.id, forKey: "id")
        saveToContext()
    }
    
    private func deleteData(by object: DiaryEntity, index: Int? = nil) {
        if let index = index {
            diaryEntities.remove(at: index)
        }
        
        self.context.delete(object)
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
