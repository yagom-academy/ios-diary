//
//  JSONData.swift
//  Diary
//
//  Created by yeton, hyeon2 on 2022/08/17.
//

import UIKit

struct JSONData {
    static func parse<T: Decodable>(name: String) -> T? {
        let jsonDecoder = JSONDecoder()
        
        guard let dataAsset = NSDataAsset(name: name) else {
            return nil
        }
        
        let data = try? jsonDecoder.decode(T.self, from: dataAsset.data)
        
        return data
    }
}
