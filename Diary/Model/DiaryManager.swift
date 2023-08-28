//
//  DiaryManager.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/08/28.
//

import UIKit

struct DiaryManager {
    private(set) var diaryList: [Diary]?
    
    mutating func updateDiary() -> Bool {
        guard let dataAsset = NSDataAsset(name: "sample") else {
            return false
        }
        
        guard let diaryList = try? JSONDecoder().decode([Diary].self, from: dataAsset.data) else {
            return false
        }
        
        self.diaryList = diaryList
        
        return true
    }
}
