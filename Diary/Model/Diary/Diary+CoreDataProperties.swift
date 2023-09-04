//
//  Diary+CoreDataProperties.swift
//  Diary
//
//  Created by Minsup, RedMango on 2023/09/04.
//
//

import CoreData

extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var createdDate: Date?

}

extension Diary : Identifiable { }
