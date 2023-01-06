//
//  Diary+CoreDataProperties.swift
//  
//
//  Created by 애종, 애쉬 on 2023/01/04.
//
//

import Foundation
import CoreData

extension Diary {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var body: String?
    @NSManaged public var createdAt: Double
    @NSManaged public var title: String?
    @NSManaged public var weatherMain: String?
    @NSManaged public var weatherIconID: String?
}
