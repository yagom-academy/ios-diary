//
//  JSONDecoder+.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/20.
//

import os.log
import UIKit

extension JSONDecoder {
    static func decode<T: Decodable>(_ type: T.Type, from asset: String) -> T? {
        let decoder: JSONDecoder = JSONDecoder()
        guard let asset = NSDataAsset(name: asset) else { return nil }
        
        do {
            return try decoder.decode(type, from: asset.data)
        } catch {
            let logger = Logger()
            logger.error("\(error.localizedDescription)")
            return nil
        }
    }
}
