//
//  AssetDiaryStorage.swift
//  Diary
//
//  Created by Erick on 2023/08/29.
//

import UIKit

final class AssetDiaryStorage: DiaryStorageProtocol {
    
    func diaryEntrys() -> [DiaryEntry] {
        guard let asset = NSDataAsset(name: "sample"),
              let diaryEntrys = try? JSONDecoder().decode([DiaryEntry].self, from: asset.data) else {
            return []
        }
        
        return diaryEntrys
    }
    
    func storeDiary(_ diary: DiaryEntry) {
        
    }
}
