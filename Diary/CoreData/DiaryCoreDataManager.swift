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
    
    func createDAO<DTO: DataTransferObject, DAO: DataAccessObject>(entityType: DAO, from data: DTO) {
        guard let entityName = entityType.entity.name else { return }
        
        guard let dao = DAO.object(entityName: entityName, context: storage.context) else { return }
        
        if let castedData = data as? DAO.DTO {
            dao.setValues(from: castedData)
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
        
        guard let dao = fetchResult.first,
              let data = data as? DAO.DTO else { return }

        dao.updateValue(data: data)
        
        if storage.context.hasChanges {
            storage.saveContext()
        }
    }
    
    func deleteDAO(id: UUID) {
        let request = DiaryDAO.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id.uuidString)
        request.predicate = predicate
        
        let fetchResult = storage.fetch(request: request)
        
        guard let diary = fetchResult.first else { return }
        
        storage.context.delete(diary)
        storage.saveContext()
    }
}
