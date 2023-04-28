//
//  Diary+CoreDataProperties.swift
//  Diary
//
//  Created by 리지, goat on 2023/04/27.
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
    @NSManaged public var date: Double

}

extension Diary: Identifiable {

}
