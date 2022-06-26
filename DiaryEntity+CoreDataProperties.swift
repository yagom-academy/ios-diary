//
//  DiaryEntity+CoreDataProperties.swift
//  Diary
//
//  Created by 김태훈 on 2022/06/23.
//
//

import Foundation
import CoreData

@objc(DiaryEntity)
public class DiaryEntity: NSManagedObject {

}

extension DiaryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryEntity> {
        return NSFetchRequest<DiaryEntity>(entityName: "DiaryEntity")
    }

    @NSManaged public var body: String?
    @NSManaged public var createdAt: Date
    @NSManaged public var title: String?
    @NSManaged public var id: String

}

extension DiaryEntity : Identifiable {

}
