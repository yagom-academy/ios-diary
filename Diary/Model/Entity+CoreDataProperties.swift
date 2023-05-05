//
//  Entity+CoreDataProperties.swift
//  Diary
//
//  Created by Seoyeon Hong on 2023/05/01.
//
//

import Foundation
import CoreData

extension Diary {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }
    
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var createdAt: Double
    @NSManaged public var uuid: UUID
    
}

extension Diary : Identifiable {

}
