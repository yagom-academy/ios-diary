//
//  CoreDataManager.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/26.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() { }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataNamespace.diary)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            guard error == nil else {
                AlertManager.shared.sendError(title: ErrorNamespace.loadingFailure)
                return
            }
        })
        return container
    }()
    
    private var diaryEntity: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: CoreDataNamespace.diary, in: persistentContainer.viewContext)
    }
    
    private func saveContext() throws {
        if persistentContainer.viewContext.hasChanges {
            try persistentContainer.viewContext.save()
        }
    }
    
    func insert(date: Date) throws {
        guard let diaryEntity = diaryEntity else { return }
        
        let managedObject = NSManagedObject(entity: diaryEntity, insertInto: persistentContainer.viewContext)
        managedObject.setValue(date, forKey: CoreDataNamespace.createAt)
        try saveContext()
    }
    
    func fetchAllEntities() throws -> [Diary] {
        let request = Diary.fetchRequest()
        return try persistentContainer.viewContext.fetch(request)
    }
    
    func fetchID(date: Date) -> NSManagedObjectID? {
        let fetchRequest = Diary.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: CoreDataNamespace.regex,
                                             argumentArray: [date])
        
        let result = try? persistentContainer.viewContext.fetch(fetchRequest)
        return result?.first?.objectID
    }
    
    func update(_ diaryItem: DiaryModel?) throws {
        guard let diaryItem = diaryItem,
              let id = diaryItem.id else { return }
        
        guard let object = persistentContainer.viewContext.object(with: id) as? Diary else { return }
        
        object.setValue(diaryItem.title, forKey: CoreDataNamespace.title)
        object.setValue(diaryItem.body, forKey: CoreDataNamespace.body)
        try saveContext()
    }
    
    func delete(with id: NSManagedObjectID?) throws {
        guard let id = id else { return }
        
        let object = persistentContainer.viewContext.object(with: id)
        persistentContainer.viewContext.delete(object)
        try saveContext()
    }
    
    private enum CoreDataNamespace {
        static let title = "title"
        static let body = "body"
        static let createAt = "createdAt"
        static let diary = "Diary"
        static let regex = "createdAt == %@"
    }
    
    private enum ErrorNamespace {
        static let loadingFailure = "데이터 로딩 실패"
        static let saveError = "데이터 저장 실패"
    }
}
