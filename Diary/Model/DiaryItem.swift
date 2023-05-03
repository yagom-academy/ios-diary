//
//  DiaryItem.swift
//  Diary
//
//  Created by Christy, vetto on 2023/04/24.
//
//import Foundation
//
//struct DiaryItem {
//    let title: String?
//    let body: String?
//    let createDate: Double
//    let id: UUID?
//
//    private enum CodingKeys: String, CodingKey {
//        case title
//        case body
//        case createDate = "created_at"
//    }
//
//    init(title: String? = nil,
//         body: String? = nil,
//         createDate: Double = Date().timeIntervalSince1970,
//         id: UUID? = UUID()) {
//        self.title = title
//        self.body = body
//        self.createDate = createDate
//        self.id = id
//    }
//}
