//
//  DiaryInfo.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/16.
//

import Foundation

//추후 Decodable 제거
struct DiaryInfo: Decodable {
    let title: String?
    let body: String?
    let date: Date?
    let key: Int64?
}
