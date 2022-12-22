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
        guard let dataAsset = NSDataAsset(name: "sample") else { return nil }
        
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return try? jsonDecoder.decode([DiaryForm].self, from: dataAsset.data)
    }
}
