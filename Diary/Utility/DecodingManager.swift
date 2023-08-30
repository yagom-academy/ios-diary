//
//  DecodingManager.swift
//  Diary
//
//  Created by Mary & Whales on 2023/08/30.
//

import UIKit

struct DecodingManager {
    static func decodeJSON<Value: Decodable>(fileName: String) throws -> Value {
        let decoder = JSONDecoder()
        
        guard let dataAsset = NSDataAsset(name: fileName) else {
            throw DataError.notFoundAsset
        }
        
        guard let decodedData: Value = try? decoder.decode(Value.self, from: dataAsset.data) else {
            throw DataError.failedDecoding
        }
        
        return decodedData
    }
}
