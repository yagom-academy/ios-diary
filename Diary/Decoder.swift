//
//  JSONDecoder.swift
//  Diary
//
//  Created by hyunMac on 1/2/24.
//

import Foundation

struct Decoder {
    static func decodeJSON<T:Codable>(data: Data, type: T.Type) -> T? {
        let decoder = JSONDecoder()
        
        do {
            let decodeData = try decoder.decode(type, from: data)
            return decodeData
        } catch {
            print("\(error) 발생")
            return nil
        }
    }
}
