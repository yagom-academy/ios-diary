//
//  CoreDataManager.swift
//  Diary
//
//  Created by Hyejeong Jeong on 2023/04/28.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() { }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    private lazy var context: NSManagedObjectContext = persistentContainer.viewContext
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func create(contents: Contents) {
        guard let entity = NSEntityDescription.entity(forEntityName: "ContentsEntity", in: context),
              let storage = NSManagedObject(entity: entity, insertInto: context) as? ContentsEntity else { return }
        
        storage.setValue(contents.title, forKey: "title")
        storage.setValue(contents.body, forKey: "body")
        storage.setValue(contents.date, forKey: "date")
        storage.setValue(contents.identifier, forKey: "identifier")
        
        saveContext()
    }
    
    func read() -> [Contents]? {
        let fetchRequest = NSFetchRequest<ContentsEntity>(entityName: "ContentsEntity")
        
        do {
            let fetchedData = try context.fetch(fetchRequest)
            return entitiesToContents(fetchedData)
        } catch {
            return nil
        }
    }
    
    private func entitiesToContents(_ contentsEntities: [ContentsEntity]) -> [Contents] {
        var contents = [Contents]()
        
        contentsEntities.forEach {
            let content = Contents(title: $0.title ?? "",
                                   body: $0.body ?? "",
                                   date: $0.date,
                                   identifier: $0.identifier ?? UUID())
            
            contents.append(content)
        }
        
        return contents
    }
}
