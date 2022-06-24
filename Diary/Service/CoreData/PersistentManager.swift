//
//  PersistentManager.swift
//  Diary
//
//  Created by dudu, papri on 2022/06/17.
//

import CoreData

final class PersistentManager {
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    private let persistentContainer: NSPersistentContainer
    
    private var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext () {
        guard mainContext.hasChanges else { return }
        
        do {
            try mainContext.save()
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

// MARK: Diary CRUD

extension PersistentManager {
    func create(data: Diary) {
        let entity = DiaryEntity(context: mainContext)
        
        entity.title = data.title
        entity.body = data.body
        entity.createdDate = data.createdDate
        entity.id = data.id
        
        saveContext()
    }
    
    func fetchAll() -> [DiaryEntity]? {
        let request = DiaryEntity.fetchRequest()
        let sortByDate = NSSortDescriptor(key: "createdDate", ascending: false)
        request.sortDescriptors = [sortByDate]
        
        return try? mainContext.fetch(request)
    }
    
    private func fetch(id: String) -> DiaryEntity? {
        let request = DiaryEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        request.predicate = predicate
        
        return try? mainContext.fetch(request).first
    }
    
    func update(data: Diary) {
        guard let entity = fetch(id: data.id) else { return }
        
        entity.title = data.title
        entity.body = data.body
        entity.createdDate = data.createdDate
        
        saveContext()
    }
    
    func delete(data: Diary) {
        guard let entity = fetch(id: data.id) else { return }
        
        mainContext.delete(entity)
        saveContext()
    }
}
