//
//  DiaryEntry.swift
//  Diary
//
//  Created by Erick on 2023/08/29.
//

import Foundation

struct DiaryEntry: Hashable {
    let id: UUID
    var title: String
    var body: String
    let creationDate: String
}
