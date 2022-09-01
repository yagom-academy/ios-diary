//
//  Diary+CoreDataProperties.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/09/01.
//
//

import UIKit
import CoreData

extension Diary {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var body: String
    @NSManaged public var createdAt: Date
    @NSManaged public var weatherIcon: String?
    @NSManaged public var id: UUID
    @NSManaged public var weatherIconImage: UIImage?
    @NSManaged public var weatherMainData: String?
    @NSManaged public var title: String
}
