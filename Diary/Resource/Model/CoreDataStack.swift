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
    
    func insertDiary(_ diaryForm: DiaryForm) {
        if let entity = diaryEntity {
            let managedObject = NSManagedObject(entity: entity, insertInto: viewContext)
            managedObject.setValue(diaryForm.id, forKey: "id")
            managedObject.setValue(diaryForm.title, forKey: "title")
            managedObject.setValue(diaryForm.body, forKey: "body")
            managedObject.setValue(diaryForm.createdAt, forKey: "createdAt")
            saveContext()
        }
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
    
    func fetchDiaryForm() -> [DiaryForm] {
        var diaryForm: [DiaryForm] = []
        let fetchResults = fetchDiary()
        
        for result in fetchResults {
            let diary = DiaryForm(id: result.id,
                                  title: result.title ?? "",
                                  body: result.body ?? "",
                                  createdAt: result.createdAt ?? Date())
            diaryForm.append(diary)
        }
        
        return diaryForm
    }
    
    func updateDiary(_ diaryForm: DiaryForm) {
        let fetchRequest: NSFetchRequest<Diary> = NSFetchRequest(entityName: "Diary")
        fetchRequest.predicate = NSPredicate(format: "id == %@", diaryForm.id.uuidString)
        
        do {
            let value = try viewContext.fetch(fetchRequest)
            let valueUpdate = value[0]
            valueUpdate.setValue(diaryForm.id, forKeyPath: "id")
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteDiary(_ diaryForm: DiaryForm) {
        let fetchResults = fetchDiary()
        let diaryForm = fetchResults.filter({ $0.id == diaryForm.id })[0]
        viewContext.delete(diaryForm)
        saveContext()
    }
}
