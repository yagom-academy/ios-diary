//
//  Diary.swift
//  Diary
//
//  Created by MINT, BMO on 2023/08/28.
//

import Foundation

struct Diary {
    let title: String
    let body: String
    let date: Int
    private enum CodingKeys: String, CodingKey {
        case title
        case body
        case date = "created_at"
    }
}
