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
              let diarys = try? JSONDecoder().decode([Diary].self, from: asset.data) else {
            return []
        }
        
        let diaryEntrys = diarys.map {
            $0.diaryEntry()
        }
        
        return diaryEntrys
    }
    
    func storeDiary(_ diary: DiaryEntry) {
        
    }
}
