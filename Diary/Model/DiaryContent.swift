//
//  DiaryContent.swift
//  Diary
//
//  Created by Derrick kim on 2022/08/16.
//

struct DiaryContent: Decodable {
    let title: String
    let body: String
    let createdAt: Int
}
