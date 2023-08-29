//
//  Diary.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/08/29.
//

import Foundation

struct Diary: Hashable {
    let identifier: UUID
    let title: String
    let body: String
    let createdDate: Int
}
