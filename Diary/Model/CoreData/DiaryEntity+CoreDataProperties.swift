//
//  DiaryEntity+CoreDataProperties.swift
//  Diary
//
//  Created by Hyun A Song on 2023/09/11.
//
//

import Foundation
import CoreData


extension DiaryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryEntity> {
        return NSFetchRequest<DiaryEntity>(entityName: "DiaryEntity")
    }

    @NSManaged public var date: Double
    @NSManaged public var body: String?
    @NSManaged public var title: String?

}

extension DiaryEntity : Identifiable {

}
