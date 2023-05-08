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
    
    private var container: NSPersistentContainer?
    
    private init() { }
    
    private func getContext(completion: @escaping (Result<NSManagedObjectContext, CoreDataError>) -> Void) {
        guard let container = self.container else {
            let container = NSPersistentContainer(name: "Diary")
            container.loadPersistentStores { _, error in
                guard error == nil else {
                    completion(.failure(.persistentLoadError))
                    return
                }
            }
            
            self.container = container
            completion(.success(container.viewContext))
            return
        }
        completion(.success(container.viewContext))
    }
    
    func createContent(_ content: String?, _ date: Double, completion: @escaping (Result<Diary, CoreDataError>) -> Void) {
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
                    completion(.failure(.createError))
                }
                
                completion(.success(diary))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchContent(completion: @escaping (Result<[Diary], CoreDataError>) -> Void) {
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
                    completion(.failure(.fetchError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateContent(at diary: Diary, _ content: String?, completion: @escaping (Result<Void, CoreDataError>) -> Void) {
        getContext { result in
            switch result {
            case .success(let context):
                do {
                    let item = try context.existingObject(with: diary.objectID)
                    
                    item.setValue(content, forKey: "content")
                    
                    try context.save()
                    completion(.success(()))
                } catch {
                    completion(.failure(.updateError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteContent(at diary: Diary, completion: @escaping (Result<Void, CoreDataError>) -> Void) {
        getContext { result in
            switch result {
            case .success(let context):
                do {
                    let item = try context.existingObject(with: diary.objectID)
                    
                    context.delete(item)
                    
                    try context.save()
                    completion(.success(()))
                } catch {
                    completion(.failure(.deleteError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
