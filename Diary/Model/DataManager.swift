//
//  DataManager.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/08/29.
//

import UIKit

struct DataManager {
    func diary(diaryList: [DiaryData]) -> [Diary] {
        return diaryList.map {
            let createdDate = DateFormatter().dateString(from: Date(timeIntervalSinceReferenceDate: Double($0.createdDate)), at: DateFormatter.Location.korea, with: DateFormatter.FormatTemplate.attached)
            return Diary(identifier: UUID(), title: $0.title, body: $0.body, createdDate: createdDate)
        }
    }
}
