//
//  CoreDataManager.swift
//  Diary
//
//  Created by 두기, marisol on 2022/06/20.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var entity: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: "DiaryModel", in: context)
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func create(_ diaryData: TestData) {
        guard let entity = entity else {
            return
        }
        
        let diary = NSManagedObject(entity: entity, insertInto: context)
        diary.setValue(diaryData.title, forKey: "title")
        diary.setValue(diaryData.body, forKey: "body")
        diary.setValue(diaryData.createdAt, forKey: "createdAt")
        diary.setValue(diaryData.id, forKey: "id")
        
        saveContext()
    }
    
    func read() throws -> [DiaryModel] {
        var diaryModels: [DiaryModel] = []
        
        do {
            let request = DiaryModel.fetchRequest()
            diaryModels = try context.fetch(request)
        } catch {
            throw error
        }
        
        return diaryModels
    }
    
    func update(_ diaryData: TestData) throws {
        let predicate = NSPredicate(format: "id == %@", diaryData.id.uuidString)
        let request = DiaryModel.fetchRequest()
        request.predicate = predicate
        
        do {
            let fetchResult = try context.fetch(request)
            guard let diaryToUpdate = fetchResult.first else {
                return
            }
            diaryToUpdate.setValue(diaryData.title, forKey: "title")
            diaryToUpdate.setValue(diaryData.body, forKey: "body")
            diaryToUpdate.setValue(diaryData.createdAt, forKey: "createdAt")
        } catch {
            throw error
        }
        
        saveContext()
    }
}
