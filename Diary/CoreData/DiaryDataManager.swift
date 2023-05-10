//
//  DiaryDataManager.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/05/09.
//

import Foundation

struct DiaryDataManager {
    let coreDataManager = CoreDataManager()
    
    func create(data: Diary) {
        let diaryDAO = coreDataManager.createDAO(type: DiaryDAO.self)
        let weatherDAO = coreDataManager.createDAO(type: WeatherDAO.self)
        
        diaryDAO?.weather = weatherDAO
        diaryDAO?.setValues(from: data)
        
        if let weather = data.weather {
            weatherDAO?.setValues(from: weather)
        }
        
        coreDataManager.saveContext()
    }
}
