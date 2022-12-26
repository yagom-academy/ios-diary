//  Diary - DiaryManageable.swift
//  Created by Ayaan, zhilly on 2022/12/26

import Foundation
import CoreData

protocol DiaryManageable {
    func add(title: String, body: String, createAt: Date)
    func fetchDiaries() -> [Diary]
    func update(_ diary: Diary)
    func remove(_ diary: Diary)
}
