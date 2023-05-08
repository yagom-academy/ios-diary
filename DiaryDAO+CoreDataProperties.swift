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
    
//    @nonobjc public static func fetchRequest() -> NSFetchRequest<DiaryDAO> {
//        return NSFetchRequest<DiaryDAO>(entityName: "DiaryDAO")
//    }

    @NSManaged public var body: String?
    @NSManaged public var date: Double
    @NSManaged public var id: UUID
    @NSManaged public var title: String?

}

extension DiaryDAO: Identifiable { }

extension DiaryDAO: DataAccessObject {
    typealias DTO = Diary
    
    convenience init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?, data: Diary) {
        self.init(entity: entity, insertInto: context)
        
        self.title = data.title
        self.body = data.body
        self.date = data.updatedDate
        self.id = data.id
    }
    
    func setValues(from data: DTO) {
        self.title = data.title
        self.body = data.body
        self.date = data.updatedDate
        self.id = data.id
    }
    
    func updateValue(data: Diary) {
        self.title = data.title
        self.body = data.body
        self.date = data.updatedDate
    }
}
