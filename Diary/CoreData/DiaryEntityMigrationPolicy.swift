//
//  Abc.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/05/09.
//

import CoreData

class DiaryEntityMigrationPolicy: NSEntityMigrationPolicy {
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        let destMOC = manager.destinationContext
        
        guard let destinationEntity = mapping.destinationEntityName else { return }
        
        guard let content = sInstance.value(forKey: "content"),
              let date = sInstance.value(forKey: "date") as? Double else { return }
        
        let context = NSEntityDescription.insertNewObject(forEntityName: destinationEntity, into: destMOC)
        
        context.setValue(content, forKey: "content")
        context.setValue(Date(timeIntervalSince1970: date), forKey: "date")
    }
}
