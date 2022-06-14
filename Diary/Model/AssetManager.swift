//
//  AssetManager.swift
//  Diary
//
//  Created by 김태현 on 2022/06/13.
//

import UIKit

struct AssetManager {
    private func convert(fileName: String) -> Data? {
        guard let assetFile = NSDataAsset(name: fileName) else {
            return nil
        }
        
        return assetFile.data
    }
    
    private func parseData() -> [SampleData]? {
        guard let data = convert(fileName: "sample") else {
            return nil
        }
        
        guard let sampleData = SampleData.parse(data: data) else {
            return nil
        }
        
        return sampleData
    }
    
    func getData() -> [DiaryData]? {
        guard let sampleData = parseData() else {
            return nil
        }
        
        let diaryData = sampleData.map {
            DiaryData(data: $0)
        }
        
        return diaryData
    }
}
