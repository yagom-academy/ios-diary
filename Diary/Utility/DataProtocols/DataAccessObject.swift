//
//  DataAccessObject.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/05/06.
//

import CoreData

protocol DataAccessObject: AnyObject, NSManagedObject {
    associatedtype Domain: DataTransferObject
    
    static func fetchRequest() -> NSFetchRequest<Self>?
    
    func updateValue(data: Domain)
    func setValues(from data: Domain)
}

extension DataAccessObject {
    static func fetchRequest() -> NSFetchRequest<Self>? {
        guard let entityName = Self.entity().name else {
            return nil
        }
        
        return NSFetchRequest<Self>(entityName: entityName)
    }
    
    static func object(entityName: String, context: NSManagedObjectContext) -> Self? {
        guard let entityDescription = NSEntityDescription.entity(
            forEntityName: entityName,
            in: context
        ) else { return nil }
        guard let object = NSManagedObject(entity: entityDescription, insertInto: context) as? Self else { return nil }
        
        return object
    }
}
