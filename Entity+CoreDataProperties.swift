//
//  Entity+CoreDataProperties.swift
//  Diary
//
//  Created by 박종화 on 2023/09/14.
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
    @NSManaged public var createdDate: Int64

}

extension Entity : Identifiable {

}
