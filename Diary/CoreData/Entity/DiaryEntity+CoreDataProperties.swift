//
//  DiaryEntity+CoreDataProperties.swift
//  Diary
//
//  Created by MINT, BMO on 2023/09/04.
//
//

import Foundation
import CoreData

extension DiaryEntity {
    @NSManaged var id: UUID
    @NSManaged var body: String?
    @NSManaged var date: Date
    @NSManaged var title: String
}

extension DiaryEntity: Identifiable {

}

extension DiaryEntity: EntityProtocol {
    var entityName: String {
        return "DiaryEntity"
    }
}
