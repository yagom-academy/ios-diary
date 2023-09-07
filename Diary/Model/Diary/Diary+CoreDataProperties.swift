//
//  Diary+CoreDataProperties.swift
//  Diary
//
//  Created by Minsup, RedMango on 2023/09/07.
//
//

import Foundation
import CoreData

extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        let request = NSFetchRequest<Diary>(entityName: "Diary")
        let createdDateSort = NSSortDescriptor(keyPath: \Diary.createdDate, ascending: false)
        request.sortDescriptors = [createdDateSort]
        
        return request
    }

    @NSManaged public var content: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var title: String?

}

extension Diary: Identifiable { }
