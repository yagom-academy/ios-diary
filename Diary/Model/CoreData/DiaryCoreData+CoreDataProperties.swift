//
//  DiaryCoreData+CoreDataProperties.swift
//  Diary
//
//  Created by 허건 on 2022/08/25.
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
    @NSManaged public var createdAt: Double

}

extension DiaryCoreData: Identifiable {

}
