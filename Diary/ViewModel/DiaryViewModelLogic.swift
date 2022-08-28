//
//  DiaryViewModelLogic.swift
//  Diary
//
//  Created by Hugh,Derrick kim on 2022/08/27.
//

import Foundation

protocol DiaryViewModelLogic {
    func save(_ text: String, _ date: Date)
    func fetch()
    func update(_ text: String)
    func remove()
}
