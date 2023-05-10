//
//  DiaryEntity+CoreDataProperties.swift
//  Diary
//
//  Created by rilla, songjun on 2023/05/02.
//
//

import Foundation
import CoreData

extension DiaryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryEntity> {
        return NSFetchRequest<DiaryEntity>(entityName: "DiaryEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var timeIntervalSince1970: Int32
    @NSManaged public var id: UUID
    @NSManaged public var iconData: Data

}

extension DiaryEntity: Identifiable { }
