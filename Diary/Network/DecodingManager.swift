//
//  DecodingManager.swift
//  Diary
//
//  Created by hoon, karen on 2023/09/14.
//

import Foundation

struct DecodingManager {
    static func decodeData<T: Decodable>(from data: Data) throws -> T {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(T.self, from: data) else {
            throw DecodingError.decodingFailure
        }
        
        return decodedData
    }
}
