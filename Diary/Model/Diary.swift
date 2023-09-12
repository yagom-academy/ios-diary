//
//  Diary.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/08/29.
//

import Foundation

struct Diary: Hashable {
    let identifier: UUID
    var title: String
    var body: String
    let createdDate: String
}
