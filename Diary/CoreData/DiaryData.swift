//
//  DiaryContent.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/20.
//

import CoreData
import Foundation

struct DiaryData {
    let title: String?
    let body: String?
    let createdAt: Double
    let objectID: NSManagedObjectID
    
    var createdDateString: String {
        return Date(timeIntervalSince1970: createdAt).localizedString()
    }
}
