//  Diary - DiaryCoreDataStack.swift
//  Created by Ayaan, zhilly on 2022/12/26

import CoreData

final class DiaryCoreDataStack {
    static let shared = DiaryCoreDataStack()
    
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
    
    private init() {}
    
    func fetchEntity(forEntityName entityName: String) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName, in: context)
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
                NotificationCenter.default.post(name: .didChangeDiaryCoreData, object: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
