//
//  DataManageable.swift
//  Diary
//
//  Created by 백곰, 주디 on 2022/08/30.
//

import Foundation

protocol DataManageable {
    func saveDiary(item: DiaryItem)
    func deleteDiary(id: UUID)
    func fetchDiary() -> [DiaryItem]?
}
