//
//  JSONParser.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/14.
//

import UIKit

struct JSONParser {
    private let decoder = JSONDecoder()
    
    func decode<T: Decodable>(from fileName: String) -> [T]? {
        guard let assetData = NSDataAsset(name: fileName) else {
            return nil
        }
        
        let decodedData = try? decoder.decode([T].self, from: assetData.data)
        return decodedData
    }
}
