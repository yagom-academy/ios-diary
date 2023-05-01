//
//  Entity+CoreDataProperties.swift
//  Diary
//
//  Created by Jinah Park on 2023/05/01.
//
//

import Foundation
import CoreData

extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var date: Double

}

extension Entity: Identifiable {

}
