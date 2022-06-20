//
//  Diary+CoreDataProperties.swift
//  Diary
//
//  Created by 김태현 on 2022/06/20.
//
//

import Foundation
import CoreData


extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var body: String?
    @NSManaged public var date: Date?
    @NSManaged public var title: String?
    @NSManaged public var identifier: UUID?

}

extension Diary : Identifiable {

}
