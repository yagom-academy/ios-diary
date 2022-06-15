//
//  DiaryData.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/14.
//

import UIKit

struct DiaryData: Decodable {
    private(set) var title: String
    private(set) var date: Date
    private(set) var body: String
    
    init(title: String = "", date: Date = Date(), body: String = "") {
        self.title = title
        self.date = date
        self.body = body
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case date = "created_at"
    }
}
