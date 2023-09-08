//
//  DiaryEntry.swift
//  Diary
//
//  Created by Erick on 2023/08/29.
//

import Foundation

struct DiaryEntry: Hashable {
    let id: UUID
    let title: String
    let body: String
    let creationDate: String
}
