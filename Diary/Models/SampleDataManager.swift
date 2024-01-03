//
//  SampleDataManager.swift
//  Diary
//
//  Created by Toy, Morgan on 1/3/24.
//

import UIKit

struct SampleDataManager {
    func getDiaryData() -> [DiaryData]? {
        guard let asset = NSDataAsset(name: "sample") else { return nil }
        
        let jsonDecoder = JSONDecoder()
        
        do {
            let data = try jsonDecoder.decode([DiaryData].self, from: asset.data)
            return data
        } catch {
            print(error)
            return nil
        }
    }
}
