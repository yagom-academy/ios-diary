//
//  Diary+CoreDataProperties.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/26.
//
//

import CoreData

extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: DiaryCoreData.entityName)
    }

    @NSManaged public var body: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var title: String?
    @NSManaged public var id: UUID?
}
