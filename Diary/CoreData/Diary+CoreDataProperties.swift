//
//  Diary+CoreDataProperties.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/28.
//

import CoreData

extension Diary {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var createdAt: Double
}
