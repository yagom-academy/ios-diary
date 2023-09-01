//
//  Diary+CoreDataProperties.swift
//  Diary
//
//  Created by Max, Hemg on 2023/09/01.
//
//

import Foundation
import CoreData

extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?

}

extension Diary: Identifiable {}
