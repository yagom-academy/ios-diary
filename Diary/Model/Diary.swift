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
    var weather: Weather?
    var id: UUID
    
    var updatedDateText: String {
        let date = Date(timeIntervalSince1970: self.updatedDate)
        let formattedDate = DateFormatter.diaryForm.string(from: date)
        
        return formattedDate
    }
    
    init(title: String?, body: String?, updatedDate: Double, id: UUID = UUID()) {
        self.title = title
        self.body = body
        self.updatedDate = updatedDate
        self.id = id
    }
    
    init(diaryDAO: DiaryDAO) {
        self.title = diaryDAO.title
        self.body = diaryDAO.body
        self.updatedDate = diaryDAO.date
        self.id = diaryDAO.id
        
        if let weatherDAO = diaryDAO.weather {
            self.weather = Weather(weatherDAO: weatherDAO)
        }
    }

    func updateWeather(data: Weather) {
        if self.weather != nil {
            self.weather = data
        }
    }
}
