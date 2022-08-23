//
//  DiaryEntity+CoreDataProperties.swift
//  Diary
//
//  Created by 이은찬 on 2022/08/23.
//
//

import Foundation
import CoreData


extension DiaryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryEntity> {
        return NSFetchRequest<DiaryEntity>(entityName: "DiaryEntity")
    }

    @NSManaged public var body: String?
    @NSManaged public var createdAt: Double
    @NSManaged public var title: String?
    @NSManaged public var uuid: UUID?

}

extension DiaryEntity: Identifiable {
    
}
