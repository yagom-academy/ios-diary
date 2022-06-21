//
//  DiaryModel+CoreDataProperties.swift
//  
//
//  Created by LIMGAUI on 2022/06/21.
//
//

import Foundation
import CoreData

extension DiaryModel {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryModel> {
    return NSFetchRequest<DiaryModel>(entityName: "DiaryModel")
  }
  
  @NSManaged public var title: String?
  @NSManaged public var content: String?
  @NSManaged public var createdDate: Date?
}
