//
//  DiaryCoreData+CoreDataProperties.swift
//  Diary
//
//  Created by 리지, goat on 2023/04/27.
//
//

import Foundation
import CoreData

extension DiaryCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryCoreData> {
        return NSFetchRequest<DiaryCoreData>(entityName: "DiaryCoreData")
    }

    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var date: Double
    @NSManaged public var weatherState: String?
    @NSManaged public var icon: String?
}

extension DiaryCoreData: Identifiable {

}
