//
//  DiaryContent.swift
//  Diary
//
//  Created by Hugh, Derrick on 2022/08/16.
//

import Foundation

struct DiaryContent: Decodable, Hashable {
    var id = UUID()
    let title: String
    let body: String
    let createdAt: Double
}
