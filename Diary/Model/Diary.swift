//
//  Diary.swift
//  Diary
//
// Created by SeHong on 2023/04/24.
//

import Foundation

struct Diary: Decodable {
    
    let title: String
    let body: String
    let createdAt: Double
    
}

extension Diary {
    static let new: Diary = .init(title: "", body: "", createdAt: Date().timeIntervalSince1970)
}
