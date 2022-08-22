//
//  DiaryEntity+CoreDataProperties.swift
//  
//
//  Created by dhoney96 on 2022/08/22.
//
//

import Foundation
import CoreData


extension DiaryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryEntity> {
        return NSFetchRequest<DiaryEntity>(entityName: "DiaryEntity")
    }

    @NSManaged public var createdAt: String?
    @NSManaged public var body: String?
    @NSManaged public var title: String?

}
