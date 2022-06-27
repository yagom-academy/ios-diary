//
//  Diary+CoreDataProperties.swift
//  Diary
//
//  Created by 김태현 on 2022/06/27.
//
//

import Foundation
import CoreData

extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var body: String?
    @NSManaged public var date: Date?
    @NSManaged public var identifier: UUID?
    @NSManaged public var title: String?
    @NSManaged public var icon: String?
    @NSManaged public var feelsLike: Double
    @NSManaged public var tempMin: Double
    @NSManaged public var tempMax: Double
    @NSManaged public var pressure: Double
    @NSManaged public var humidity: Double
    @NSManaged public var temp: Double

}

extension Diary: Identifiable {

}
