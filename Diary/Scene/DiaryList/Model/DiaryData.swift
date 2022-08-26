//
//  DiaryData.swift
//  Diary
//
//  Created by 재재, 그루트 on 2022/08/26.
//

struct DiaryData: DiaryDataManagerProtocol {
    var diaryItems: [DiaryModel]?
    
    init() {
        self.diaryItems = CoreDataManager.shared.read()
    }
}
