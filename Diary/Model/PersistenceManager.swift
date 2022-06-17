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
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DiaryEntity")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError( )
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func fetchData(request: NSFetchRequest<DiaryEntity>) -> [DiaryEntity] {
        do {
            let fetchResult = try self.context.fetch(request)
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func createData(data: Diary) {
        let entity = NSEntityDescription.entity(forEntityName: "Joke", in: self.context)
        if let entity = entity {
            let diary = NSManagedObject(entity: entity, insertInto: self.context)
            diary.setValue(data.title, forKey: "title")
            diary.setValue(data.body, forKey: "body")
            diary.setValue(data.createdAt, forKey: "createdAt")
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteData(object: NSManagedObject) {
        self.context.delete(object)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func modifyData() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
