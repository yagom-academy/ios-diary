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
        return self.persistentContainer.viewContext
    }
    
    private init() { }
    
    // MARK: - Create
    func createContent(_ content: String?, _ date: Double) throws -> Diary {
        let diaryContext = Diary(context: context)
        
        diaryContext.content = content
        diaryContext.date = date
        
        do {
            try context.save()
            
            return diaryContext
        } catch {
            throw error
        }
    }
    
    // MARK: - Read
    func fetchContent() throws -> [Diary] {
        let fetchRequest = NSFetchRequest<Diary>(entityName: "Diary")
        let sort = NSSortDescriptor(key: "date", ascending: false)
        
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let diaryData = try context.fetch(fetchRequest)
            
            return diaryData
        } catch {
            throw error
        }
    }
    
    // MARK: - Update
    func updateContent(at diary: Diary, _ content: String?, _ date: Double) throws {
        do {
            let item = try context.existingObject(with: diary.objectID)
            
            item.setValue(content, forKey: "content")
            item.setValue(date, forKey: "date")
            
            try context.save()
        } catch {
            throw error
        }
    }
    
    // MARK: - Delete
    func deleteContent(at diary: Diary) throws {
        do {
            let item = try context.existingObject(with: diary.objectID)
            
            context.delete(item)
            try context.save()
        } catch {
            throw error
        }
    }
}
