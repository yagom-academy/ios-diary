//
//  DiaryData.swift
//  Diary
//
//  Created by 김태현 on 2022/06/14.
//

import Foundation

struct DiaryData: Hashable {
    let identifier = UUID()
    
    let title: String
    let date: String
    let body: String
    
    init(data: SampleData) {
        title = data.title
        date = Formatter.setUpDate(from: data.date)
        body = data.body
    }
}
