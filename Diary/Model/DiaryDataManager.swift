//
//  DiaryDataManager.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/08/29.
//

struct DiaryDataManager {
    func diary(diaryList: [DiaryData]) -> [Diary] {
        return diaryList.map {
            return $0.toDomain()
        }
    }
}
