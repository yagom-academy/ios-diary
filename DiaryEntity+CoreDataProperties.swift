//
//  DiaryEntity+CoreDataProperties.swift
//  Diary
//
//  Created by Erick on 2023/09/04.
//
//

import Foundation
import CoreData

extension DiaryEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryEntity> {
        return NSFetchRequest<DiaryEntity>(entityName: "DiaryEntity")
    }
    
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var creationDate: Int32
    @NSManaged public var id: UUID?
    
}

extension DiaryEntity: Identifiable {}

