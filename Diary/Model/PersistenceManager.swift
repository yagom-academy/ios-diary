//
//  PersistenceManager.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/05/02.
//

import Foundation
import CoreData

final class PersistenceManager {
    static var shared: PersistenceManager = PersistenceManager()
    
    private let persistentContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    private var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    private init() { }
    
    func createContent(_ content: String?, _ date: Double) throws -> Diary? {
        guard let entity = NSEntityDescription.entity(forEntityName: "Diary", in: context) else {
            return nil
        }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: self.context)
        
        managedObject.setValue(content, forKey: "content")
        managedObject.setValue(date, forKey: "date")
        
        guard let diary = managedObject as? Diary else { return nil }
        
        try context.save()
        
        return diary
    }
    
    func fetchContent() throws -> [Diary] {
        let fetchRequest = NSFetchRequest<Diary>(entityName: "Diary")
        let sort = NSSortDescriptor(key: "date", ascending: false)
        
        fetchRequest.sortDescriptors = [sort]
        
        let diaryData = try context.fetch(fetchRequest)
        
        return diaryData
    }
    
    func updateContent(at diary: Diary, _ content: String?) throws {
        let item = try context.existingObject(with: diary.objectID)
        
        item.setValue(content, forKey: "content")
        
        try context.save()
    }
    
    func deleteContent(at diary: Diary) throws {
        let item = try context.existingObject(with: diary.objectID)
        
        context.delete(item)
        
        try context.save()
    }
}
