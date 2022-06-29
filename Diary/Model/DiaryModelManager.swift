//
//  DiaryModelManager.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/29.
//

import Foundation

struct DiaryModelManger {
    let diaryEntityManager = DiaryEntityManager()
    
    func create(title: String, body: String, createdAt: Date, id: String) {
        diaryEntityManager.create(diary: DiaryModel(title: title, body: body, createdAt: createdAt, id: UUID().uuidString))
    }
    
    func update(title: String, body: String, createdAt: Date, id: String) {
        diaryEntityManager.update(diary: DiaryModel(title: title, body: body, createdAt: createdAt, id: id))
    }
    
    func update(diaryData: DiaryModel) {
        diaryEntityManager.update(diary: diaryData)
    }
}
