//
//  Diary+CoreDataProperties.swift
//  Diary
//
//  Created by Kiwon Song on 2022/08/25.
//
//

import Foundation
import CoreData


extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var body: String?
    @NSManaged public var title: String?
    @NSManaged public var createdAt: Double
    @NSManaged public var id: UUID?
}

extension Diary : Identifiable {

}
