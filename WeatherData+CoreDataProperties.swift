//
//  WeatherData+CoreDataProperties.swift
//  Diary
//
//  Created by Kyo, Baem on 2023/01/05.
//
//

import Foundation
import CoreData

extension WeatherData {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherData> {
        return NSFetchRequest<WeatherData>(entityName: "WeatherData")
    }

    @NSManaged public var iconID: String?
    @NSManaged public var main: String?
    @NSManaged public var diary: DiaryData?
}

extension WeatherData: Identifiable {
}
