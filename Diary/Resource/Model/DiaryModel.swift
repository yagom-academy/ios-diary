//
//  DiaryModel.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/20.
//

import Foundation
import CoreData

struct DiaryModel {
    let id: UUID
    var title: String
    var body: String
    let createdAt: Date
}
