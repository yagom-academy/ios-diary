//
//  CoreDataManager.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/09/04.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared: CoreDataManager = CoreDataManager()
    let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {}
    
    func create(diary: Diary) {
        let object = Diary(context: context)
        object.setValue(diary.title, forKey: "title")
        object.setValue(diary.body, forKey: "body")
        object.setValue(diary.createdAt, forKey: "createdAt")
        object.setValue(diary.identifier, forKey: "identifier")
        saveContext()
    }
    
    func fetchAllDiaries() -> [Diary] {
        var data: [Diary] = []
        data = fetch(fetchRequest)
        
        return data
    }
    
    func fetchSingleDiary(by uuid: UUID) -> [Diary] {
        var data: [Diary] = []
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid.uuidString)
        data = fetch(fetchRequest)
        
        return data
    }
    
    private func fetch(_ request: NSFetchRequest<Diary>) -> [Diary] {
        do {
            let data = try context.fetch(request)
            return data
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    func update(newDiary: Diary) {
        var diary = fetchSingleDiary(by: newDiary.identifier!)
        diary[safe: 0]!.title = newDiary.title
        diary[safe: 0]!.body = newDiary.body
        diary[safe: 0]!.createdAt = newDiary.createdAt
        saveContext()
    }
    
    func delete(diary uuid: UUID) {
        guard let diary = fetchSingleDiary(by: uuid)[safe: 0] else {
            return
        }
        
        persistentContainer.viewContext.delete(diary)
        saveContext()
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("세이브 성공")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
