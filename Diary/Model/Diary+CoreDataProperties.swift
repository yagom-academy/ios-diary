//
//  Diary+CoreDataProperties.swift
//  Diary
//
//  Created by Andrew, brody on 2023/05/02.
//

import CoreData

extension Diary {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }
    
    @NSManaged public var title: String
    @NSManaged public var body: String
    @NSManaged public var createdAt: Date
    @NSManaged public var id: UUID
}

extension Diary : Identifiable {
}
