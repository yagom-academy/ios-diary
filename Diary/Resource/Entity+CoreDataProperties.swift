//
//  Entity+CoreDataProperties.swift
//  Diary
//  Created by inho, dragon on 2022/12/27.
//

import CoreData
import Foundation

extension Entity {
    @nonobjc static func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: NameSpace.entityName)
    }

    @NSManaged var title: String?
    @NSManaged var body: String?
    @NSManaged var createdDate: String?
    @NSManaged var totalText: String?
    @NSManaged var id: UUID?
    @NSManaged var icon: String?
}

private enum NameSpace {
    static let entityName = "Entity"
}
