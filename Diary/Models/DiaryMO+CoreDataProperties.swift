//
//  DiaryMO+CoreDataProperties.swift
//  Diary
//
//  Created by junho lee on 2022/12/27.
//
//

import Foundation
import CoreData

extension DiaryMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryMO> {
        return NSFetchRequest<DiaryMO>(entityName: "Diary")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var body: String
    @NSManaged public var createdAt: Double

}

extension DiaryMO: Identifiable {

}
