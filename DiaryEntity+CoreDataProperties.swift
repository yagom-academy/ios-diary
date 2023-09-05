//
//  DiaryEntity+CoreDataProperties.swift
//  Diary
//
//  Created by MINT, BMO on 2023/09/04.
//
//

import Foundation
import CoreData

extension DiaryEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryEntity> {
        return NSFetchRequest<DiaryEntity>(entityName: "DiaryEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var body: String?
    @NSManaged public var date: Date
    @NSManaged public var title: String

}

extension DiaryEntity: Identifiable {

}
