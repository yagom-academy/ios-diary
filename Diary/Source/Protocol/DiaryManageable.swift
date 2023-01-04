//  Diary - DiaryManageable.swift
//  Created by Ayaan, zhilly on 2022/12/26

import Foundation
import CoreData

protocol CoreDataManageable {
    associatedtype Object: ManagedObjectModel
    
    func add(_ object: Object?) throws
    func fetchObjects() throws -> [Object] 
    func update(_ object: Object) throws
    func remove(_ object: Object) throws
}
