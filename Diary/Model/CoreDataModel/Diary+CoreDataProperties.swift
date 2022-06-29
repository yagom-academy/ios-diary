//
//  Diary+CoreDataProperties.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/21.
//
//

import Foundation
import CoreData


extension Diary {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
    return NSFetchRequest<Diary>(entityName: "Diary")
  }
  
  @NSManaged public var content: String?
  @NSManaged public var createdDate: Date?
  @NSManaged public var identifier: String?
  @NSManaged public var title: String?
  @NSManaged public var main: String?
  @NSManaged public var iconID: String?

  
}

extension Diary : Identifiable {}
