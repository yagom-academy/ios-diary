//
//  DiaryModel.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/20.
//

import Foundation
import CoreData

struct DiaryModel {
    var id: NSManagedObjectID?
    var title: String
    var body: String
    var createdAt: Date
}
