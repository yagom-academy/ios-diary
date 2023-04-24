//
//  Decoder.swift
//  Diary
//
//  Created by 리지, Goat on 2023/04/24.
//

import UIKit

enum Decoder {
    static func parseJSON<element: Decodable>(fileName: String, returnType: element.Type) -> element? {
        let jsonDecoder = JSONDecoder()
        guard let dataAsset = NSDataAsset(name: fileName) else { return nil }
        
        do {
            let result = try jsonDecoder.decode(returnType, from: dataAsset.data)
            
            return result
        } catch {
            print(error.localizedDescription)
            
            return nil
        }
    }
}
