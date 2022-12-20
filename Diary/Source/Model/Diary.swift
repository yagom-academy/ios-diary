//
//  Diary.swift
//  Diary
//  Created by inho, dragon on 2022/12/20.
//

import Foundation

struct Diary: Decodable {
    let title: String
    let body: String
    let createdAt: Int
}
