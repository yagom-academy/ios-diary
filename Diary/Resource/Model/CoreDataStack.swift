//
//  CoreDataStack.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/26.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var diaryEntity: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: "Diary", in: viewContext)
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func insertDiary(_ diaryModel: DiaryModel?) {
        guard let diaryModel = diaryModel,
              let diaryEntity = diaryEntity else { return }
        
        let managedObject = NSManagedObject(entity: diaryEntity, insertInto: viewContext)
        managedObject.setValue(diaryModel.title, forKey: "title")
        managedObject.setValue(diaryModel.body, forKey: "body")
        managedObject.setValue(diaryModel.createdAt, forKey: "createdAt")
        saveContext()
    }
    
    func fetchDiary(with id: NSManagedObjectID?) -> Diary? {
        guard let id = id else { return nil }
        
        guard let object = viewContext.object(with: id) as? Diary else { return nil }
        
        return object
    }
    
    func fetchAllDiaries() -> [Diary] {
        do {
            let request = Diary.fetchRequest()
            let results = try viewContext.fetch(request)
            
            return results
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func fetchAllDiaryModels() -> [DiaryModel] {
        var diaryModels: [DiaryModel] = []
        let fetchedResults = fetchAllDiaries()
        
        for result in fetchedResults {
            let diary = DiaryModel(id: result.objectID,
                                  title: result.title ?? "",
                                  body: result.body ?? "",
                                   createdAt: result.createdAt ?? Date())
            diaryModels.append(diary)
        }
        
        return diaryModels
    }
    
    func updateDiary(_ diaryModel: DiaryModel?) {
        guard let diaryModel = diaryModel,
              let id = diaryModel.id else { return }
        
        guard let object = viewContext.object(with: id) as? Diary else { return }
        
        object.setValue(diaryModel.title, forKeyPath: "title")
        object.setValue(diaryModel.body, forKey: "body")
        saveContext()
    }
    
    func deleteDiary(with id: NSManagedObjectID?) {
        guard let id = id else { return }
        
        let object = viewContext.object(with: id)
        viewContext.delete(object)
        saveContext()
    }
}
