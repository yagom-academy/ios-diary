//
//  DiaryEntity+CoreDataProperties.swift
//  
//
//  Created by 박세웅 on 2022/06/17.
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
    @NSManaged public var createdAt: Double

}
