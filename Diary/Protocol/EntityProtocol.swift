//
//  EntityProtocol.swift
//  Diary
//
//  Created by MINT, BMO on 2023/09/12.
//

import CoreData

protocol EntityProtocol where Self: NSManagedObject {
    var entityName: String { get }
}

extension EntityProtocol {
    func fetchRequest() -> NSFetchRequest<Self> {
        return NSFetchRequest<Self>(entityName: entityName)
    }
}
