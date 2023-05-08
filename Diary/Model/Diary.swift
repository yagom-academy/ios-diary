//
//  Diary.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/25.
//

import Foundation

final class Diary: DataTransferObject {
    var title, body: String?
    var updatedDate: Double
    var id = UUID()
    
    var updatedDateText: String {
        let date = Date(timeIntervalSince1970: self.updatedDate)
        let formattedDate = DateFormatter.diaryForm.string(from: date)
        
        return formattedDate
    }
    
    init(title: String?, body: String?, updatedDate: Double) {
        self.title = title
        self.body = body
        self.updatedDate = updatedDate
    }
    
    init(diaryDAO: DiaryDAO) {
        self.title = diaryDAO.title
        self.body = diaryDAO.body
        self.updatedDate = diaryDAO.date
        self.id = diaryDAO.id
    }

    func updateContents(title: String?, body: String?, updatedDate: Double) {
        self.title = title
        self.body = body
        self.updatedDate = updatedDate
    }
}
