//
//  Diary+CoreDataProperties.swift
//  Diary
//
//  Created by leewonseok on 2022/12/28.
//
//

import Foundation
import CoreData

extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var id: UUID
    @NSManaged public var createdAt: Double
    @NSManaged public var text: String

}

extension Diary: Identifiable { }
