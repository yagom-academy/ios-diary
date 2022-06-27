//
//  DiaryEntity+CoreDataProperties.swift
//  Diary
//
//  Created by dudu, papri on 17/06/2022.
//
//

import Foundation
import CoreData

extension DiaryEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryEntity> {
        return NSFetchRequest<DiaryEntity>(entityName: "DiaryEntity")
    }

    @NSManaged public var body: String
    @NSManaged public var createdDate: Date
    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var weather: String?
    @NSManaged public var weatherIcon: String?
}

extension DiaryEntity: Identifiable {}
