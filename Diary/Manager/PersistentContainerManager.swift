//
//  PersistentContainerManager.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/26.
//

import CoreData
import UIKit.UIApplication

final class PersistentContainerManager {
    static let shared = PersistentContainerManager()
    
    // MARK: - properties
    
    private let persistentContainer: NSPersistentContainer = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return NSPersistentContainer() }
        let container = appDelegate.persistentContainer
        
        return container
    }()
    
    private lazy var context = persistentContainer.viewContext
    
    // MARK: - functions
    
    func fetch<T>(request: NSFetchRequest<T>, predicate: NSPredicate? = nil) -> [T] {
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        var data = [T]()
        
        do {
            data = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        
        return data
    }
    
    func create(entityName: String, values: [String: Any]) {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        else { return }
        
        let content = NSManagedObject(entity: entity, insertInto: context)
        
        values.forEach { content.setValue($0.value, forKey: $0.key) }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func update(object: NSManagedObject, values: [String: Any]) {
        values.forEach { object.setValue($0.value, forKey: $0.key) }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete(object: NSManagedObject) {
        context.delete(object)
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

