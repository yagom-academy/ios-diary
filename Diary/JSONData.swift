//
//  JSONData.swift
//  Diary
//
//  Created by yeton, hyeon2 on 2022/08/17.
//

import UIKit

struct JSONData {
    static func parse<T: Decodable>(name: String, decodableType: T) -> T? {
        let jsonDecoder = JSONDecoder()
        let parsedItemsType = type(of: decodableType)
        
        guard let dataAsset = NSDataAsset(name: name) else {
            return nil
        }
        
        let data = try? jsonDecoder.decode(parsedItemsType.self, from: dataAsset.data)
        
        return data
    }
}
