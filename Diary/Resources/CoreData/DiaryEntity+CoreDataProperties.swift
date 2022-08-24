//
//  DiaryEntity+CoreDataProperties.swift
//  Diary
//
//  Created by 민쏜, 보리사랑 on 2022/08/24.
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
    @NSManaged public var createdDate: Date?

}

extension DiaryEntity : Identifiable {

}
