//
//  DiaryData+CoreDataProperties.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/26.
//
//

import Foundation
import CoreData

extension DiaryData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryData> {
        return NSFetchRequest<DiaryData>(entityName: "DiaryData")
    }

    @NSManaged public var titleText: String?
    @NSManaged public var contentText: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
}

extension DiaryData: Identifiable {
}

