//
//  CoreDataManageable.swift
//  Diary
//
//  Created by SummerCat and som on 2023/01/05.
//

import Foundation
import CoreData

protocol CoreDataManageable {
    func insert(with id: UUID) throws
    func fetch(with id: NSManagedObjectID?) -> Diary?
    func fetchAllEntities() throws -> [Diary]
    func fetchObjectID(with id: UUID) -> NSManagedObjectID?
    func update(objectID: NSManagedObjectID?, title: String?, body: String?) throws
    func delete(with id: NSManagedObjectID?) throws
}
