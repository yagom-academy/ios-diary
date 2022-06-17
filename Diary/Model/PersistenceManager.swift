//
//  PersistenceManager.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/17.
//

import Foundation
import CoreData

final class PersistenceManager {
    static let shared = PersistenceManager()
    private init() { }
    
    private var diaryEntities = [DiaryEntity]()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DiaryEntity")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError( )
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func fetchData() {
        do {
            let request = DiaryEntity.fetchRequest()
            let fetchResult = try self.context.fetch(request)
            diaryEntities = fetchResult
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func diaries() -> [DiaryEntity] {
        diaryEntities
    }
}

extension PersistenceManager {
    private func createData(data: Diary) {
        let entity = NSEntityDescription.entity(forEntityName: "DiaryEntity", in: self.context)
        if let entity = entity {
            let diary = NSManagedObject(entity: entity, insertInto: self.context)
            diary.setValue(data.title, forKey: "title")
            diary.setValue(data.body, forKey: "body")
            diary.setValue(data.createdAt, forKey: "createdAt")
            diary.setValue(data.id, forKey: "id")
            
            saveContext()
        }
    }
    
    func updateData(data: Diary) {
        let request: NSFetchRequest<DiaryEntity> = DiaryEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", data.id)
        request.predicate = predicate
        
        do {
            let fetchedResults = try context.fetch(request)
            if fetchedResults.first == nil {
                createData(data: data)
            } else {
                patchData()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func patchData() {
        if context.hasChanges {
            saveContext()
        }
    }
    
    func deleteData(object: NSManagedObject) {
        self.context.delete(object)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
