//
//  DiaryModel+CoreDataProperties.swift
//  Diary
//
//  Created by 두기, marisol on 2022/06/28.
//
//

import Foundation
import CoreData

extension DiaryModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryModel> {
        return NSFetchRequest<DiaryModel>(entityName: "DiaryModel")
    }

    @NSManaged public var body: String?
    @NSManaged public var createdAt: Double
    @NSManaged public var id: UUID
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var weatherModel: WeatherModel?

}

extension DiaryModel: Identifiable {

}
