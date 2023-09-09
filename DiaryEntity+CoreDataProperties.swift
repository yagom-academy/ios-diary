//
//  DiaryEntity+CoreDataProperties.swift
//  Diary
//
//  Created by Erick on 2023/09/08.
//
//

import Foundation
import CoreData

extension DiaryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryEntity> {
        return NSFetchRequest<DiaryEntity>(entityName: "DiaryEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var body: String?
    @NSManaged public var creationDate: Date
}

extension DiaryEntity: Identifiable {}

extension DiaryEntity {
    func diaryEntry() -> DiaryEntry {
        let timeStamp = DateFormatManager.timestamp(date: creationDate)
        let dateFormatString = DateFormatManager.string(localeDateFormatter: UserDateFormatter.shared, timestamp: timeStamp)
        
        return DiaryEntry(id: id, title: title, body: body ?? "", creationDate: dateFormatString)
    }
}
