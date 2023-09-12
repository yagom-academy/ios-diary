//
//  AssetDiaryStorage.swift
//  Diary
//
//  Created by Erick on 2023/08/29.
//

import UIKit

final class AssetDiaryReader: DiaryReadable {
    
    func diaryEntrys() throws -> [DiaryEntry] {
        guard let asset = NSDataAsset(name: "sample"),
              let diarys = try? JSONDecoder().decode([Diary].self, from: asset.data) else {
            throw StorageError.loadDataFailed
        }
        
        let diaryEntrys = diarys.map {
            $0.diaryEntry()
        }
        
        return diaryEntrys
    }
}
