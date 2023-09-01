//
//  DiaryService.swift
//  Diary
//
//  Created by MINT, BMO on 2023/09/02.
//

import UIKit

struct DiaryService {
    func loadDiaryList(name: String) throws -> [Diary] {
        let asset = try loadAsset(name: name)
        let diaryList = try decodeJSON([Diary].self, asset: asset)
        
        return diaryList
    }
    
    private func loadAsset(name: String) throws -> NSDataAsset {
        guard let asset = NSDataAsset(name: name) else {
            throw DataLoadError.assetNotFound
        }
        
        return asset
    }
    
    private func decodeJSON<T: Decodable>(_ type: T.Type, asset: NSDataAsset) throws -> T {
        let decoder = JSONDecoder()
        
        guard let decodeData = try? decoder.decode(type, from: asset.data) else {
            throw DataLoadError.decodeFailure
        }
        
        return decodeData
    }
}
