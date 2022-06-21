//
//  DiaryData+CoreDataProperties.swift
//  
//
//  Created by 우롱차, RED on 2022/06/16.
//
//

import Foundation
import CoreData

extension DiaryData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryData> {
        return NSFetchRequest<DiaryData>(entityName: "DiaryData")
    }

    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var date: Date?
    @NSManaged public var key: UUID

}
