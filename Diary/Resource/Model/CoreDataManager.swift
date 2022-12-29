//
//  CoreDataManager.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/26.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataNamespace.diary)
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
        return NSEntityDescription.entity(forEntityName: CoreDataNamespace.diary, in: viewContext)
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
        managedObject.setValue(diaryModel.title, forKey: CoreDataNamespace.title)
        managedObject.setValue(diaryModel.body, forKey: CoreDataNamespace.body)
        managedObject.setValue(diaryModel.createdAt, forKey: CoreDataNamespace.createAt)
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
                                   title: result.title ?? Namespace.emptyString,
                                   body: result.body ?? Namespace.emptyString,
                                   createdAt: result.createdAt ?? Date())
            diaryModels.append(diary)
        }
        
        return diaryModels
    }
    
    func fetchID(of diaryModel: DiaryModel?) -> NSManagedObjectID? {
        guard let diaryModel = diaryModel else { return nil }

        let fetchRequest = Diary.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: CoreDataNamespace.regex,
                                               argumentArray: [diaryModel.title, diaryModel.body, diaryModel.createdAt])
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            return result.first?.objectID
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func updateDiary(_ diaryModel: DiaryModel?) {
        guard let diaryModel = diaryModel,
              let id = diaryModel.id else { return }
        
        guard let object = viewContext.object(with: id) as? Diary else { return }
        
        object.setValue(diaryModel.title, forKey: CoreDataNamespace.title)
        object.setValue(diaryModel.body, forKey: CoreDataNamespace.body)
        saveContext()
    }
    
    func deleteDiary(with id: NSManagedObjectID?) {
        guard let id = id else { return }
        
        let object = viewContext.object(with: id)
        viewContext.delete(object)
        saveContext()
    }
    
    private enum CoreDataNamespace {
        static let title = "title"
        static let body = "body"
        static let createAt = "createdAt"
        static let diary = "Diary"
        static let regex = "title == %@ AND body == %@ AND createdAt == %@"
    }
}
