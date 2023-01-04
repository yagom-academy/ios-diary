//
//  DiaryModelObject+CoreDataProperties.swift
//  Diary
//
//  Created by Mangdi on 2022/12/27.
//
//

import Foundation
import CoreData

extension DiaryModelObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryModelObject> {
        return NSFetchRequest<DiaryModelObject>(entityName: "DiaryModelObject")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var body: String
    @NSManaged public var createdAt: Double
    @NSManaged public var main: String?
    @NSManaged public var iconID: String?
}

extension DiaryModelObject: Identifiable {

}
