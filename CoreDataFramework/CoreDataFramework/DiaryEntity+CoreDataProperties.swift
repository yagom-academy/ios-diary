//
//  DiaryEntity+CoreDataProperties.swift
//  CoreDataFramework
//
//  Created by 백곰, 주디 on 2022/08/25.
//
//

import Foundation
import CoreData

extension DiaryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryEntity> {
        return NSFetchRequest<DiaryEntity>(entityName: "DiaryEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var body: String
    @NSManaged public var createdAt: Double

}

extension DiaryEntity: Identifiable {

}
