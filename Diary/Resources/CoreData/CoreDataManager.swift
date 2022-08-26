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
    
    
    
    // MARK: - Initializer
    
    private init() {
        
    }
    
    // MARK: - Methods

    func saveDiary(title: String, body: String, createdAt: Date) throws {
        let diary = Diary(context: viewContext)
        diary.setValue(title, forKey: DiaryCoreData.Key.title)
        diary.setValue(body, forKey: DiaryCoreData.Key.body)
        diary.setValue(createdAt, forKey: DiaryCoreData.Key.createdAt)

        if viewContext.hasChanges {
            try viewContext.save()
        }
    }

    func fetchDiary(createdAt: Date) throws -> Diary {
        let request = NSFetchRequest<Diary>(entityName: DiaryCoreData.entityName)
        request.predicate = NSPredicate(
            format: DiaryCoreData.Predicate.creationDate,
            createdAt as NSDate
        )
        
        
        return diary
    }
    
    func update(title: String, body: String, createdAt: Date) throws {
        let fetchRequest = NSFetchRequest<Diary>(entityName: DiaryCoreData.entityName)
        fetchRequest.predicate = NSPredicate(
            format: DiaryCoreData.Predicate.creationDate,
            createdAt as NSDate
        )
        
        guard let diary =
                try viewContext.fetch(fetchRequest).first else {
            throw FetchingError.invalidFetchRequest
        }
        
        diary.title = title
        diary.body = body
        
        if viewContext.hasChanges {
            try viewContext.save()
        }
    }
    
    func delete(createdAt: Date) throws {
        let fetchRequest = NSFetchRequest<Diary>(entityName: DiaryCoreData.entityName)
        fetchRequest.predicate = NSPredicate(
            format: DiaryCoreData.Predicate.creationDate,
            createdAt as NSDate
        )
        
        
        viewContext.delete(diary)
        
        if viewContext.hasChanges {
            try viewContext.save()
        }
    }
}
