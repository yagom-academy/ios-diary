//
//  DiaryItem.swift
//  Diary
//
//  Created by Christy, vetto on 2023/04/24.
//

struct DiaryItem: Decodable {
    let title: String
    let body: String
    let createDate: Int

    private enum CodingKeys: String, CodingKey {
        case title
        case body
        case createDate = "created_at"
    }
}
