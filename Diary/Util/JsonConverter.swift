//
//  JsonConverter.swift
//  Diary
//
//  Created by SeHong on 2023/04/24.
//

import UIKit

enum JsonConverter {
    
    private static let jsonDecoder = JSONDecoder()
    private let sampleData = "sample"
    
    static func decode() -> [Diary]? {
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let dataAsset = NSDataAsset(name: sampleData) else { return nil }
        guard let result = try? jsonDecoder.decode([Diary].self, from: dataAsset.data) else { return nil }
        
        return result
    }
    
}
