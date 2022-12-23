//
//  JsonDecoderManager.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/21.
//

import UIKit

struct JSONDecoderManager {
    let jsonDecoder = JSONDecoder()

    func convertJSONData() -> [DiaryForm]? {
        let sampleData = "sample"
        guard let dataAsset = NSDataAsset(name: sampleData) else { return nil }
        
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return try? jsonDecoder.decode([DiaryForm].self, from: dataAsset.data)
    }
}
