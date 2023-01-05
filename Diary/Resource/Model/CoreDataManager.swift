//
//  CoreDataManager.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/26.
//

import Foundation
import CoreData
import UIKit

final class CoreDataManager: CoreDataManageable {
    static let shared = CoreDataManager()
    weak var alertDelegate: AlertDelegate? {
        let scene = UIApplication.shared.connectedScenes.first
        guard let sceneDelegate: SceneDelegate = scene?.delegate as? SceneDelegate,
              let delegate = sceneDelegate.window?.rootViewController as? AlertDelegate else {
            return nil
        }
        
        return delegate
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataNamespace.diary)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            guard error == nil else {
                self.alertDelegate?.showErrorAlert(title: CoreDataNamespace.loadFailure)
                return
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var diaryEntity: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: CoreDataNamespace.diary, in: context)
    }

    private init() { }
    
    func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
    func insert(with id: UUID) throws {
        guard let diaryEntity = diaryEntity else { return }
        
        let managedObject = NSManagedObject(entity: diaryEntity, insertInto: context)
        managedObject.setValue(id, forKey: CoreDataNamespace.id)
        managedObject.setValue(Date(), forKey: CoreDataNamespace.createdAt)
        try saveContext()
    }
    
    func fetch(with id: NSManagedObjectID?) -> Diary? {
        guard let id = id else { return nil }
        
        return context.object(with: id) as? Diary
    }
    
    func fetchAllEntities() throws -> [Diary] {
        let request = Diary.fetchRequest()
        return try context.fetch(request)
    }
    
    func fetchObjectID(with id: UUID) -> NSManagedObjectID? {
        let fetchRequest = Diary.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: CoreDataNamespace.regex, id.uuidString)
        
        let result = try? context.fetch(fetchRequest)
        return result?.first?.objectID
    }
    
    func update(objectID: NSManagedObjectID?, title: String?, body: String?) throws {
        guard let objectID = objectID else { return }
        
        guard let object = context.object(with: objectID) as? Diary else { return }
        
        object.setValue(title, forKey: CoreDataNamespace.title)
        object.setValue(body, forKey: CoreDataNamespace.body)
        try saveContext()
    }
    
    func delete(with id: NSManagedObjectID?) throws {
        guard let id = id else { return }
        
        let object = context.object(with: id)
        context.delete(object)
        try saveContext()
    }
    
    private enum CoreDataNamespace {
        static let id = "id"
        static let title = "title"
        static let body = "body"
        static let createdAt = "createdAt"
        static let diary = "Diary"
        static let regex = "id == %@"
        static let loadFailure = "코어 데이터 로드 실패"
    }
}
