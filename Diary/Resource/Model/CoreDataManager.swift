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
                fatalError("init(coder:) has not been implemented")
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
    
    func insert(with id: UUID) throws {
        guard let diaryEntity = diaryEntity else { return }
        
        let managedObject = NSManagedObject(entity: diaryEntity, insertInto: persistentContainer.viewContext)
        managedObject.setValue(id, forKey: CoreDataNamespace.id)
        managedObject.setValue(Date(), forKey: CoreDataNamespace.createdAt)
        try saveContext()
    }
    
    func fetch(with id: NSManagedObjectID?) -> Diary? {
        guard let id = id else { return nil }
        
        return persistentContainer.viewContext.object(with: id) as? Diary
    }
    
    func fetchAllEntities() throws -> [Diary] {
        let request = Diary.fetchRequest()
        return try persistentContainer.viewContext.fetch(request)
    }
    
    func fetchObjectID(with id: UUID) -> NSManagedObjectID? {
        let fetchRequest = Diary.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: CoreDataNamespace.regex, id.uuidString)
        
        let result = try? persistentContainer.viewContext.fetch(fetchRequest)
        return result?.first?.objectID
    }
    
    func update(objectID: NSManagedObjectID?, title: String?, body: String?) throws {
        guard let objectID = objectID else { return }
        
        guard let object = persistentContainer.viewContext.object(with: objectID) as? Diary else { return }
        
        object.setValue(title, forKey: CoreDataNamespace.title)
        object.setValue(body, forKey: CoreDataNamespace.body)
        try saveContext()
    }
    
    func delete(with id: NSManagedObjectID?) throws {
        guard let id = id else { return }
        
        let object = persistentContainer.viewContext.object(with: id)
        persistentContainer.viewContext.delete(object)
        try saveContext()
    }
    
    private enum CoreDataNamespace {
        static let id = "id"
        static let title = "title"
        static let body = "body"
        static let createdAt = "createdAt"
        static let diary = "Diary"
        static let regex = "id == %@"
    }
    
    private enum ErrorNamespace {
        static let loadingFailure = "데이터 로딩 실패"
        static let saveError = "데이터 저장 실패"
    }
}
