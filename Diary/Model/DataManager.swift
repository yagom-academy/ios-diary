//
//  DataManager.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/08/29.
//

import UIKit

struct DataManager {
    func diary(diaryList: [DiaryData]) -> [Diary] {
        let dataFormatter = DateFormatter()
        return diaryList.map {
            let createdDate = dataFormatter.dateString(
                from: Date(timeIntervalSince1970: Double($0.createdDate)),
                at: Locale.current.identifier,
                with: DateFormatter.FormatTemplate.attached
            )
            return Diary(
                identifier: UUID(),
                title: $0.title,
                body: $0.body,
                createdDate: createdDate
            )
        }
    }
}
