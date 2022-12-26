//
//  JSONDecoder+.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/20.
//

import UIKit

extension JSONDecoder {
    static func decode<T: Decodable>(_ type: T.Type, from asset: String) -> T? {
        let decoder: JSONDecoder = JSONDecoder()
        guard let asset = NSDataAsset(name: asset) else { return nil }
        
        return try? decoder.decode(type, from: asset.data)
    }
}
