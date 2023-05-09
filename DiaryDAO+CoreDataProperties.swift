//
//  DiaryDAO+CoreDataProperties.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/05/09.
//
//

import Foundation
import CoreData

extension DiaryDAO {
    @NSManaged public var body: String?
    @NSManaged public var date: Double
    @NSManaged public var id: UUID
    @NSManaged public var title: String?
    @NSManaged public var weather: WeatherDAO?
}

extension DiaryDAO: Identifiable { }

extension DiaryDAO: DataAccessObject {
    typealias Domain = Diary
    
    func setValues(from data: Domain) {
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
