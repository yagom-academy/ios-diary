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
    
//    private let persistentContainer: NSPersistentContainer = {
//       let container = NSPersistentContainer(name: "Diary")
//        container.loadPersistentStores { _, error in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        }
//
//        return container
//    }()
//    private var context: NSManagedObjectContext {
//        return self.persistentContainer.viewContext
//    }
    
    private init() { }
    
    private func getContext(completion: @escaping (Result<NSManagedObjectContext, NSError>) -> Void) {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                completion(.failure(error))
            }
        }
        
        completion(.success(container.viewContext))
    }
    
    func createContent(_ content: String?, _ date: Double, completion: @escaping (Result<Diary, Error>) -> Void) {
        getContext { result in
            switch result {
            case .success(let context):
                guard let entity = NSEntityDescription.entity(forEntityName: "Diary", in: context) else { return }
                
                let managedObject = NSManagedObject(entity: entity, insertInto: context)
                
                managedObject.setValue(content, forKey: "content")
                managedObject.setValue(date, forKey: "date")
                
                guard let diary = managedObject as? Diary else { return }
                
                do {
                    try context.save()
                } catch {
                    completion(.failure(error))
                }
                
                completion(.success(diary))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
//        guard let entity = NSEntityDescription.entity(forEntityName: "Diary", in: context) else {
//            return nil
//        }
//
//        let managedObject = NSManagedObject(entity: entity, insertInto: self.context)
//
//        managedObject.setValue(content, forKey: "content")
//        managedObject.setValue(date, forKey: "date")
//
//        guard let diary = managedObject as? Diary else { return nil }
//
//        try context.save()
//
//        return diary
    }
    
    func fetchContent(completion: @escaping (Result<[Diary], Error>) -> Void) {
        let fetchRequest = NSFetchRequest<Diary>(entityName: "Diary")
        let sort = NSSortDescriptor(key: "date", ascending: false)
        
        fetchRequest.sortDescriptors = [sort]
        
        getContext { result in
            switch result {
            case .success(let context):
                do {
                    let diaryData = try context.fetch(fetchRequest)
                    completion(.success(diaryData))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
//        let diaryData = try context.fetch(fetchRequest)
//
//        return diaryData
    }
    
    func updateContent(at diary: Diary, _ content: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        getContext { result in
            switch result {
            case .success(let context):
                do {
                    let item = try context.existingObject(with: diary.objectID)
                    
                    item.setValue(content, forKey: "content")
                    
                    try context.save()
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        
//        let item = try context.existingObject(with: diary.objectID)
//
//        item.setValue(content, forKey: "content")
//
//        try context.save()
    }
    
    func deleteContent(at diary: Diary, completion: @escaping (Result<Void, Error>) -> Void) {
        getContext { result in
            switch result {
            case .success(let context):
                do {
                    let item = try context.existingObject(with: diary.objectID)
                    
                    context.delete(item)
                    
                    try context.save()
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
//        let item = try context.existingObject(with: diary.objectID)
//        
//        context.delete(item)
//        
//        try context.save()
    }
}
