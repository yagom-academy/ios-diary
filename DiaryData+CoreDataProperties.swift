//
//  DiaryData+CoreDataProperties.swift
//  Diary
//
//  Created by Christy, vetto on 2023/05/01.
//

import Foundation
import CoreData

extension DiaryData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryData> {
        return NSFetchRequest<DiaryData>(entityName: "DiaryData")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var createDate: Double

}

extension DiaryData: Identifiable { }
