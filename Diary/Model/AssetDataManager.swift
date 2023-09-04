//
//  AssetDataManager.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/08/29.
//

import UIKit.NSDataAsset

struct AssetDataManager {
    func fetchDiaryData() throws -> [DiaryData] {
        guard let dataAsset = NSDataAsset(name: "sample") else {
            throw DataError.notFoundAsset
        }
        
        guard let diaryList = try? JSONDecoder().decode([DiaryData].self, from: dataAsset.data) else {
            throw DataError.failedDecoding
        }
        
        return diaryList
    }
}
