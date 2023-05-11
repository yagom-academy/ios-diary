//
//  ContentsEntity+CoreDataProperties.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/04/28.
//

import CoreData

extension ContentsEntity {
    @nonobjc class func fetchRequest() -> NSFetchRequest<ContentsEntity> {
        return NSFetchRequest<ContentsEntity>(entityName: ContentsEntity.description())
    }
    
    @NSManaged var title: String?
    @NSManaged var body: String?
    @NSManaged var date: Double
    @NSManaged var identifier: UUID?
    @NSManaged var weatherType: String?
    @NSManaged var weatherIconCode: String?
}

extension ContentsEntity: Identifiable { }
