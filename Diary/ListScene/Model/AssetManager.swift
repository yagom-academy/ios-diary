//
//  AssetManager.swift
//  Diary
//
//  Created by 김태현 on 2022/06/13.
//

import UIKit

struct AssetManager {
    enum Const {
        static let sample = "sample"
    }
    
    private static func convert(fileName: String) -> Data? {
        guard let assetFile = NSDataAsset(name: fileName) else {
            return nil
        }
        
        return assetFile.data
    }
    
    static func get<T: Decodable>() -> [T]? {
        guard let assetData = AssetManager.convert(fileName: Const.sample) else {
            return nil
        }
        
        guard let diaryData = [T].parse(data: assetData) else {
            return nil
        }
        
        return diaryData
    }
}
