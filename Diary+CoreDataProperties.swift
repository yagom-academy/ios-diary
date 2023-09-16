//
//  Diary+CoreDataProperties.swift
//  Diary
//
//  Created by 예찬 on 2023/09/05.
//
//

import Foundation
import CoreData

extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var createdAt: String?
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var identifier: UUID
}

extension Diary: Identifiable {
}
