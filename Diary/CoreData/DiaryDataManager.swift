//
//  DiaryDataManager.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/05/09.
//

import Foundation

struct DiaryDataManager {
    private let coreDataManager = CoreDataManager()
    
    func create(data: Diary) {
        let diaryDAO = coreDataManager.createDAO(type: DiaryDAO.self)
        let weatherDAO = coreDataManager.createDAO(type: WeatherDAO.self)
        
        diaryDAO?.weather = weatherDAO
        diaryDAO?.setValues(from: data)
        
        coreDataManager.saveContext()
    }
    
    func readAll() -> [Diary] {
        let sortDescription = SortDescription(key: "date", ascending: false)
        let diaryDAOList = coreDataManager.readAllDAO(type: DiaryDAO.self, sortDescription: sortDescription)
        let diaryList = diaryDAOList.map { diaryDAO in
            Diary(diaryDAO: diaryDAO)
        }
        
        return diaryList
    }
    
    func update(data: Diary) {
        coreDataManager.updateDAO(type: DiaryDAO.self, data: data)
    }
    
    func delete(id: UUID) {
        coreDataManager.deleteDAO(type: DiaryDAO.self, id: id)
    }
}
