//
//  DatabaseManageable.swift
//  Diary
//
//  Created by dudu, papri on 2022/06/29.
//

import Foundation

protocol DatabaseManageable {
    func create(data: Diary)
    func read() -> [DiaryEntity]?
    func update(data: Diary)
    func delete(data: Diary)
}
