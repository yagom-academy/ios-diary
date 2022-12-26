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
    
    func insertDiary(_ diaryModel: DiaryModel) {
        guard let diaryEntity = diaryEntity else { return }
        
        let managedObject = NSManagedObject(entity: diaryEntity, insertInto: viewContext)
        managedObject.setValue(diaryModel.id, forKey: "id")
        managedObject.setValue(diaryModel.title, forKey: "title")
        managedObject.setValue(diaryModel.body, forKey: "body")
        managedObject.setValue(diaryModel.createdAt, forKey: "createdAt")
        saveContext()
    }
    
    func fetchDiary() -> [Diary] {
        do {
            let request = Diary.fetchRequest()
            let results = try viewContext.fetch(request)
            
            return results
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func fetchDiaryModel() -> [DiaryModel] {
        var diaryModels: [DiaryModel] = []
        let fetchedResults = fetchDiary()
        
        for result in fetchedResults {
            let diary = DiaryModel(id: result.id,
                                  title: result.title ?? "",
                                  body: result.body ?? "",
                                  createdAt: result.createdAt ?? Date())
            diaryModels.append(diary)
        }
        
        return diaryModels
    }
    
    func updateDiary(_ diaryModel: DiaryModel) {
        let fetchRequest: NSFetchRequest<Diary> = NSFetchRequest(entityName: "Diary")
        fetchRequest.predicate = NSPredicate(format: "id == %@", diaryModel.id.uuidString)
        
        do {
            let diaries = try viewContext.fetch(fetchRequest)
            let diaryToUpdate = diaries[0]
            diaryToUpdate.setValue(diaryModel.id, forKeyPath: "id")
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteDiary(_ diaryModel: DiaryModel) {
        let fetchRequest: NSFetchRequest<Diary> = NSFetchRequest(entityName: "Diary")
        fetchRequest.predicate = NSPredicate(format: "id == %@", diaryModel.id.uuidString)
        
        do {
            let diaries = try viewContext.fetch(fetchRequest)
            let diaryToDelete = diaries[0]
            viewContext.delete(diaryToDelete)
            saveContext()
        } catch {
            print(error.localizedDescription)
        }
    }
}
