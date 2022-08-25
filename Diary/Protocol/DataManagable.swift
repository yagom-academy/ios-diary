//
//  DataManagable.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/25.
//

import Foundation

protocol DataManagable {
    associatedtype Model
    associatedtype ModelObject
    
    func create(model: Model)
    func fetch() -> [ModelObject]
    func update(model: Model)
    func delete(_ id: UUID)
    func deleteAll()
}
