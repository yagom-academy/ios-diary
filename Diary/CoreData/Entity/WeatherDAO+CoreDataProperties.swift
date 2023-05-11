//
//  WeatherDAO+CoreDataProperties.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/05/09.
//
//

import Foundation
import CoreData

extension WeatherDAO {
    @NSManaged public var main: String?
    @NSManaged public var icon: String?
    @NSManaged public var id: UUID
    @NSManaged public var diary: DiaryDAO?
}

extension WeatherDAO: Identifiable {}

extension WeatherDAO: DataAccessObject {
    typealias Domain = Weather
    
    func setValues(from data: Domain) {
        self.main = data.main
        self.icon = data.icon
        self.id = data.id
    }
    
    func updateValue(data: Domain) {
        self.main = data.main
        self.icon = data.icon
    }
}
