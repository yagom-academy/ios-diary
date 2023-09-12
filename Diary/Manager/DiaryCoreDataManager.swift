//
//  DiaryCoreDataManager.swift
//  Diary
//
//  Created by Zion, Serena on 2023/09/11.
//

final class DiaryCoreDataManager: CoreDataManager {
    func createDiaryData(title: String, body: String, date: Double) -> DiaryEntity {
        let entity = DiaryEntity(context: context)
        
        entity.title = title
        entity.body = body
        entity.date = date
        return entity
    }
}
