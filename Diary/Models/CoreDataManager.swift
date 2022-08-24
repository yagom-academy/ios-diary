//
//  CoreDataManager.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/23.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    // MARK: Properties
    
    static let shared = CoreDataManager()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let persistentContainer: NSPersistentContainer = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer
    }()
    
    // MARK: - Initializer
    
    private init() {
        
    }
    
    // MARK: - Methods

    func saveDiary(title: String, body: String, createdAt: Date) {
        let diary = Diary(context: persistentContainer.viewContext)
        diary.setValue(title, forKey: DiaryCoreData.Key.title)
        diary.setValue(body, forKey: DiaryCoreData.Key.body)
        diary.setValue(createdAt, forKey: DiaryCoreData.Key.createdAt)

        appDelegate.saveContext()
    }

    func fetchDiary(createdAt: Date) -> Diary? {
        let request = NSFetchRequest<Diary>(entityName: DiaryCoreData.entityName)
        request.predicate = NSPredicate(
            format: DiaryCoreData.Predicate.creationDate,
            createdAt as NSDate
        )
        
        guard let fetchedData =
                try? persistentContainer.viewContext.fetch(request).first else {
            return nil
        }
        
        return fetchedData
    }
    
    func update(title: String, body: String, createdAt: Date) throws {
        let fetchRequest = NSFetchRequest<Diary>(entityName: DiaryCoreData.entityName)
        fetchRequest.predicate = NSPredicate(
            format: DiaryCoreData.Predicate.creationDate,
            createdAt as NSDate
        )
        
        do {
            guard let diary =
                    try persistentContainer.viewContext.fetch(fetchRequest).first else {
                throw FetchingError.invalidFetchRequest
            }
            
            diary.title = title
            diary.body = body
            appDelegate.saveContext()
        } catch {
            throw error
        }
    }
    
    func delete(createdAt: Date) throws {
        let fetchRequest = NSFetchRequest<Diary>(entityName: DiaryCoreData.entityName)
        fetchRequest.predicate = NSPredicate(
            format: DiaryCoreData.Predicate.creationDate,
            createdAt as NSDate
        )
        
        do {
            guard let diary =
                    try persistentContainer.viewContext.fetch(fetchRequest).last else {
                throw FetchingError.invalidFetchRequest
            }
            
            persistentContainer.viewContext.delete(diary)
            appDelegate.saveContext()
        } catch {
            throw error
        }
    }
}
