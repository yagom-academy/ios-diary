//  Diary - DiaryData+CoreDataProperties.swift
//  Created by Ayaan, zhilly on 2022/12/26

import Foundation
import CoreData

extension DiaryData {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryData> {
        return NSFetchRequest<DiaryData>(entityName: "DiaryData")
    }

    @NSManaged public var content: String?
    @NSManaged public var createdAt: Date?
}
