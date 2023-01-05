//
//  Diary.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/20.
//

import CoreData

struct DiaryModel: Hashable {
    var id: NSManagedObjectID?
    var title: String = ""
    var body: String = ""
    var weatherMain: String = ""
    var weatherIconID: String = ""
    var createdAt: Double = DateFormatter().convertDateToDouble()
}
