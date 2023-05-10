//
//  PersistenceManager.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/05/02.
//

import Foundation
import CoreData
import UIKit

final class PersistenceManager {
    private var context: NSManagedObjectContext?
    
    init() {
        self.context = getContext()
    }
    
    private func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    func createContent(_ content: String?, _ date: Double, completion: @escaping (Result<Diary, CoreDataError>) -> Void) {
        guard let context = context else { return }
        
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
    }
    
    func fetchContent(completion: @escaping (Result<[Diary], CoreDataError>) -> Void) {
        guard let context = context else { return }
        
        let fetchRequest = NSFetchRequest<Diary>(entityName: "Diary")
        let sort = NSSortDescriptor(key: "date", ascending: false)
        
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let diaryData = try context.fetch(fetchRequest)
            completion(.success(diaryData))
        } catch {
            completion(.failure(.fetchError))
        }
    }
    
    func updateContent(at diary: Diary, _ content: String?, completion: @escaping (Result<Void, CoreDataError>) -> Void) {
        guard let context = context else { return }
        
        do {
            let item = try context.existingObject(with: diary.objectID)
            
            item.setValue(content, forKey: "content")
            
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(.updateError))
        }
    }
    
    func deleteContent(at diary: Diary, completion: @escaping (Result<Void, CoreDataError>) -> Void) {
        guard let context = context else { return }
        
        do {
            let item = try context.existingObject(with: diary.objectID)
            
            context.delete(item)
            
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(.deleteError))
        }
    }
}
