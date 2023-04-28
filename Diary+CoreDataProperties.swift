//
//  Diary+CoreDataProperties.swift
//  Diary
//
//  Created by Harry on 2023/04/28.
//
//

import Foundation
import CoreData

extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: String?
    @NSManaged public var body: String?
    @NSManaged public var id: UUID?

}

extension Diary: Identifiable {}
