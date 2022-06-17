//
//  DiaryEntity+CoreDataProperties.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/17.
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
    @NSManaged public var id: String

}

extension DiaryEntity: Identifiable {

}
