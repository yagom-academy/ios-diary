//
//  WeatherModel+CoreDataProperties.swift
//  Diary
//
//  Created by 두기, marisol on 2022/06/28.
//
//

import Foundation
import CoreData

extension WeatherModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherModel> {
        return NSFetchRequest<WeatherModel>(entityName: "WeatherModel")
    }

    @NSManaged public var iconID: String?
    @NSManaged public var iconImage: Data?
    @NSManaged public var main: String?

}

extension WeatherModel: Identifiable {

}
