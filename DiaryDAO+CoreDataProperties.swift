//
//  DiaryDAO+CoreDataProperties.swift
//  Diary
//
//  Created by Harry on 2023/05/05.
//
//

import Foundation
import CoreData


extension DiaryDAO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryDAO> {
        return NSFetchRequest<DiaryDAO>(entityName: "DiaryDAO")
    }

    @NSManaged public var body: String?
    @NSManaged public var date: Double
    @NSManaged public var id: UUID
    @NSManaged public var title: String?

}

extension DiaryDAO : Identifiable {

}
