//
//  Diary+CoreDataProperties.swift
//  Diary
//
//  Created by LeeChiheon on 2022/08/29.
//
//

import Foundation
import CoreData


extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var body: String
    @NSManaged public var createdAt: Date
    @NSManaged public var icon: String
    @NSManaged public var id: UUID
    @NSManaged public var main: String
    @NSManaged public var title: String
    
}
