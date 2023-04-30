//
//  JsonConverter.swift
//  Diary
//
//  Created by SeHong on 2023/04/24.
//

import UIKit

enum JsonConverter {
    
    private static let jsonDecoder = JSONDecoder()
    
    static func decode() throws -> [Diary]? {
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let dataAsset = NSDataAsset(name: "sample") else {
            throw NetworkError.dataAssetNotFound
        }
        guard let result = try? jsonDecoder.decode([Diary].self, from: dataAsset.data) else {
            throw NetworkError.decodingFailure
        }
        
        return result
    }
    
}
