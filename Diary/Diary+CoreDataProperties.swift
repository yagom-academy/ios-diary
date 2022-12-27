//
//  Diary+CoreDataProperties.swift
//  
//
//  Created by 애종, 애쉬 on 2022/12/27.
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
    @NSManaged public var createdAt: Double
    @NSManaged public var id: UUID?

}
