//
//  DiaryEntity+CoreDataProperties.swift
//  Diary
//
//  Created by 김도연 on 2022/06/24.
//
//

import CoreData

extension DiaryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryEntity> {
        return NSFetchRequest<DiaryEntity>(entityName: "DiaryEntity")
    }

    @NSManaged public var createdDate: Date
    @NSManaged public var id: String
    @NSManaged public var body: String
    @NSManaged public var title: String

}

extension DiaryEntity: Identifiable {}
