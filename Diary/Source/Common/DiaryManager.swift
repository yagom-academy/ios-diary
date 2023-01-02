//  Diary - DiaryManager.swift
//  Created by Ayaan, zhilly on 2022/12/26

import Foundation
import CoreData

final class DiaryManager: CoreDataManageable {
    static let shared = DiaryManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {}
    
    func add(_ diary: Diary?) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: "DiaryData", in: context) else {
            return
        }
        let diaryObject = NSManagedObject(entity: entity, insertInto: context)
        
        diaryObject.setValue(diary?.content ?? String.init(), forKey: "content")
        diaryObject.setValue(diary?.createdAt ?? Date.now, forKey: "createdAt")
        
        try context.save()
    }
    
    func fetchObjects() throws -> [Diary] {
        let fetchRequest: NSFetchRequest<DiaryData> = DiaryData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        let result = try context.fetch(fetchRequest)
        
        return result.compactMap({ Diary(from: $0) })
    }
    
    func update(_ diary: Diary) throws {
        guard let objectID = fetchObjectID(from: diary.objectID) else {
            return
        }
        let object = context.object(with: objectID)
        
        object.setValue(diary.content, forKey: "content")
        
        try context.save()
    }
    
    func remove(_ diary: Diary) throws {
        guard let objectID = fetchObjectID(from: diary.objectID) else {
            return
        }
        let object = context.object(with: objectID)
        
        context.delete(object)
        try context.save()
    }
    
    private func fetchObjectID(from diaryID: String?) -> NSManagedObjectID? {
        guard let diaryID = diaryID,
              let objectURL = URL(string: diaryID),
              let storeCoordinator = context.persistentStoreCoordinator,
              let objectID = storeCoordinator.managedObjectID(forURIRepresentation: objectURL) else {
            return nil
        }
        return objectID
    }
}
