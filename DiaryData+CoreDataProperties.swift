//
//  DiaryData+CoreDataProperties.swift
//  Diary
//
//  Created by Kyo, Baem on 2023/01/05.
//
//

import Foundation
import CoreData

extension DiaryData {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryData> {
        return NSFetchRequest<DiaryData>(entityName: "DiaryData")
    }

    @NSManaged public var contentText: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var weather: WeatherData?
}

extension DiaryData: Identifiable {
}
