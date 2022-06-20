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
    
    func create(_ diaryData: DiaryData) {
        guard let entity = entity else {
            return
        }
        
        let diary = NSManagedObject(entity: entity, insertInto: context)
        diary.setValue(diaryData.title, forKey: "title")
        diary.setValue(diaryData.body, forKey: "body")
        diary.setValue(diaryData.createdAt, forKey: "createdAt")
        
        saveContext()
    }
    
    func read() throws -> [DiaryModel] {
        var diaryModels: [DiaryModel] = []
        
        do {
            diaryModels = try context.fetch(DiaryModel.fetchRequest())
        } catch {
            throw error
        }
        
        return diaryModels
    }
}
