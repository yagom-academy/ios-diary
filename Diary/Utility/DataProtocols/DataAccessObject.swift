//
//  DataAccessObject.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/05/06.
//

import CoreData

protocol DataAccessObject: AnyObject {
    associatedtype FetchResult: NSFetchRequestResult
    
    static func fetchRequest() -> NSFetchRequest<FetchResult>?
}

extension DataAccessObject where Self: NSManagedObject {
    static func fetchRequest() -> NSFetchRequest<Self>? {
        guard let entityName = Self.entity().name else { return nil }
        return NSFetchRequest<Self>(entityName: entityName)
    }
}
