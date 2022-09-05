//
//  DataManageLogic.swift
//  Diary
//
//  Created by Derrick, Hugh on 2022/08/27.
//

import Foundation

protocol DataManageLogic {
    func save(data: DiaryContent) throws
    func fetch() throws -> [DiaryContent]
    func remove(date: Date) throws
    func update(data: DiaryContent) throws
}
