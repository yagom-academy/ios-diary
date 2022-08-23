//
//  Diary+CoreDataProperties.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/23.
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
    @NSManaged public var createdAt: Date?

}

extension Diary : Identifiable {

}
