//
//  DiaryCoreDataManager.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/28.
//

import Foundation
import CoreData

struct DiaryDataManager {
    private let storage = CoreDataManager.shared
    
    func createDAO<DTO: DataTransferObject, DAO: DataAccessObject>(entityType: DAO.Type, from data: DTO) {
        guard let entityName = DAO.entity().name else {
            return
            
        }
        
        guard let object = DAO.object(entityName: entityName, context: storage.context) else { return }
        
        if let castedData = data as? DAO.DTO {
            object.setValues(from: castedData)
        }
        
        storage.saveContext()
    }
    
    func readAllDAO<DAO: DataAccessObject>(type: DAO.Type) -> [DAO] {
        guard let request = DAO.fetchRequest() else { return [] }
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        request.sortDescriptors = [sortDescriptor]
        
        let fetchResult = storage.fetch(request: request)
        
        return fetchResult
    }
    
    func updateDAO<DAO: DataAccessObject, DTO: DataTransferObject>(type: DAO.Type, data: DTO) {
        guard let request = DAO.fetchRequest() else { return }
        
        let predicate = NSPredicate(format: "id == %@", data.id.uuidString)
        request.predicate = predicate
        
        let fetchResult = storage.fetch(request: request)
        
        guard let object = fetchResult.first,
              let data = data as? DAO.DTO else { return }

        object.updateValue(data: data)
        
        if storage.context.hasChanges {
            storage.saveContext()
        }
    }
    
    func deleteDAO<DAO: DataAccessObject>(type: DAO.Type, id: UUID) {
        guard let request = DAO.fetchRequest() else { return }
        
        let predicate = NSPredicate(format: "id == %@", id.uuidString)
        request.predicate = predicate
        
        let fetchResult = storage.fetch(request: request)
        
        guard let object = fetchResult.first else { return }
        
        storage.context.delete(object)
        storage.saveContext()
    }
}
