//  Diary - DiaryManageable.swift
//  Created by Ayaan, zhilly on 2022/12/26

import Foundation
import CoreData

protocol DiaryManageable {
    func add(title: String, body: String, createAt: Date)
    func remove(_ object: NSManagedObject)
    func update(_ object: NSManagedObject)
}
