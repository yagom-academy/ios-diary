//
//  DiaryContents+CoreDataProperties.swift
//  Diary
//
//  Created by seohyeon park on 2022/08/23.
//
//

import Foundation
import CoreData

extension DiaryContents {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryContents> {
        return NSFetchRequest<DiaryContents>(entityName: "DiaryContents")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var createdAt: Double

}

extension DiaryContents: Identifiable {

}
