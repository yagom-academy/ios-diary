//
//  JSONDecoder.swift
//  Diary
//
//  Created by Toy, Morgan on 1/2/24.
//

import UIKit

struct Decoder {
    static func decodeJSON<T:Decodable>(asset: NSDataAsset, type: T.Type) -> T? {
        let decoder = JSONDecoder()
        
        do {
            let decodeData = try decoder.decode(type, from: asset.data)
            return decodeData
        } catch {
            print("\(error) 발생")
            return nil
        }
    }
}
