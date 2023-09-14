//
//  DiaryContentsDTO.swift
//  Diary
//
//  Created by Hyungmin Lee on 2023/09/14.
//

import Foundation

struct DiaryContentsDTO: Hashable {
    var body: String
    var date: Double
    var title: String
    var identifier: UUID
}
