//
//  DiaryData+CoreDataProperties.swift
//  Diary
//
//  Copyright (c) 2022 woong, jeremy All rights reserved.

import Foundation
import CoreData

extension DiaryData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryData> {
        return NSFetchRequest<DiaryData>(entityName: "DiaryData")
    }

    @NSManaged public var uuid: UUID?
    @NSManaged public var createdAt: Date?
    @NSManaged public var body: String?
    @NSManaged public var title: String?

}

extension DiaryData : Identifiable {}
