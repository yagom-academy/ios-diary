//
//  Diary+CoreDataProperties.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/22.
//
//

import Foundation
import CoreData


extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var body: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var title: String?

}
