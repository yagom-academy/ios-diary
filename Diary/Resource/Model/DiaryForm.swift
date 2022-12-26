//
//  DiaryForm.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/20.
//

import Foundation

struct DiaryForm: Decodable {
    let id: UUID
    let title: String
    let body: String
    let createdAt: Date
}
