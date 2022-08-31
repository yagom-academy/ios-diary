//
//  DiaryEntity+CoreDataProperties.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/23.
//
//

import Foundation
import CoreData

extension DiaryEntity {
    // MARK: - properties
    
    @NSManaged public var body: String?
    @NSManaged public var createdAt: Double
    @NSManaged public var title: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var icon: String
    
    // MARK: - functions
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryEntity> {
        return NSFetchRequest<DiaryEntity>(entityName: "DiaryEntity")
    }
}

extension DiaryEntity: Identifiable { }
