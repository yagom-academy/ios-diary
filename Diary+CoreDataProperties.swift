//
//  Diary+CoreDataProperties.swift
//  
//
//  Created by 변재은 on 2022/09/02.
//
//

import Foundation
import CoreData

extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var body: String
    @NSManaged public var createdAt: Double
    @NSManaged public var title: String
    @NSManaged public var main: String
    @NSManaged public var icon: Data

}
