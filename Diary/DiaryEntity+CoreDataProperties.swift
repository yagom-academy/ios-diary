//
//  DiaryEntity+CoreDataProperties.swift
//  Diary
//
//  Created by dhoney96 on 2022/08/25.
//
//

import Foundation
import CoreData


extension DiaryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryEntity> {
        return NSFetchRequest<DiaryEntity>(entityName: "DiaryEntity")
    }

    @NSManaged public var body: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var title: String?

}

extension DiaryEntity : Identifiable {

}
