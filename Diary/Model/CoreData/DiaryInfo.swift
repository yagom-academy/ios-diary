//
//  DiaryInfo.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/16.
//

import Foundation

protocol DataModelable {
    static var entityName: String { get }
}

struct DiaryInfo: DataModelable, Equatable {
    static var entityName = "DiaryData"
    
    let title: String?
    let body: String?
    let date: Date?
    let key: UUID?
//    let weather: String?
//    let icon: String?
}
