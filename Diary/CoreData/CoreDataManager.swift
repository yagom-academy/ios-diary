//
//  CoreDataManager.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/28.
//

import Foundation
import CoreData

struct CoreDataManager {
    private let storage = CoreDataStack.shared
    
    func createDAO<DAO: DataAccessObject>(type: DAO.Type) -> DAO? {
        guard let entityName = DAO.entity().name,
              let object = DAO.object(entityName: entityName, context: storage.context) else { return nil }
        
        return object
    }
    
    func readAllDAO<DAO: DataAccessObject>(type: DAO.Type, sortDescription: SortDescription?) -> [DAO] {
        guard let request = DAO.fetchRequest() else { return [] }
        
        if let sortDescription {
            let sortDescriptor = NSSortDescriptor(key: sortDescription.key,
                                                  ascending: sortDescription.ascending)
            
            request.sortDescriptors = [sortDescriptor]
        }
        
        let fetchResult = storage.fetch(request: request)
        
        return fetchResult
    }
    
    func updateDAO<DAO: DataAccessObject, Domain: DataTransferObject>(type: DAO.Type, data: Domain) {
        guard let request = DAO.fetchRequest() else { return }
        
        let predicate = NSPredicate(format: "id == %@", data.id.uuidString)
        request.predicate = predicate
        
        let fetchResult = storage.fetch(request: request)
        
        guard let object = fetchResult.first,
              let data = data as? DAO.Domain else { return }
        
        object.updateValue(data: data)
        saveContext()
    }
    
    func deleteDAO<DAO: DataAccessObject>(type: DAO.Type, id: UUID) {
        guard let request = DAO.fetchRequest() else { return }
        
        let predicate = NSPredicate(format: "id == %@", id.uuidString)
        request.predicate = predicate
        
        let fetchResult = storage.fetch(request: request)
        
        guard let object = fetchResult.first else { return }
        
        storage.context.delete(object)
        saveContext()
    }
    
    func saveContext() {
        if storage.context.hasChanges {
            do {
                try storage.context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
