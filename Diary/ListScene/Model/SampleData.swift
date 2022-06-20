//
//  SampleData.swift
//  Diary
//
//  Created by 김동욱 on 2022/06/16.
//

import Foundation

struct SampleData {
    enum Const {
        static let sample = "sample"
    }
    
    static func get() -> [DiaryDTO]? {
        guard let assetData = AssetManager.convert(fileName: Const.sample) else {
            return nil
        }
        
        guard let diaryData = DiaryDTO.parse(data: assetData) else {
            return nil
        }
        
        return diaryData
    }
}
