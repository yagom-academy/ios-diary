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

    @nonobjc final class func fetchRequest() -> NSFetchRequest<DiaryEntity> {
        return NSFetchRequest<DiaryEntity>(entityName: "DiaryEntity")
    }

    @NSManaged var id: UUID
    @NSManaged var title: String
    @NSManaged var body: String?
    @NSManaged var creationDate: Date
}

extension DiaryEntity: Identifiable {}

extension DiaryEntity {
    func diaryEntry() -> DiaryEntry {
        let timeStamp = DateFormatManager.timestamp(date: creationDate)
        let dateFormatString = DateFormatManager.string(localeDateFormatter: UserDateFormatter.shared, timestamp: timeStamp)
        
        return DiaryEntry(id: id, title: title, body: body ?? "", creationDate: dateFormatString)
    }
}
