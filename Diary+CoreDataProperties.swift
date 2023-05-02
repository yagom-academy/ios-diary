//
//  Diary+CoreDataProperties.swift
//  Diary
//
//  Created by Andrew on 2023/05/02.
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
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?

}

extension Diary : Identifiable {

}
