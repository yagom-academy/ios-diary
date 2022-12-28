//
//  Diary.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/20.
//

import UIKit
import CoreData

struct DiaryModel: Decodable, Hashable {
    var id: NSManagedObjectID!
    var title: String = ""
    var body: String = ""
    var createdAt: Double = DateFormatter().convertDateToDouble()
    
    private enum CodingKeys: String, CodingKey {
        case title, body
        case createdAt = "created_at"
    }
}
