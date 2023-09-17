//
//  DiaryEntity+CoreDataProperties.swift
//  Diary
//
//  Created by Hyungmin Lee on 2023/09/14.
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
    @NSManaged public var date: Double

}

extension DiaryEntity : Identifiable {

}
