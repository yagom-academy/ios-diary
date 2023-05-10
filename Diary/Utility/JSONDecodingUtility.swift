//
//  JSONDecodingUtility.swift
//  Diary
//
//  Created by Andrew, brody on 2023/05/10.
//

import Foundation

class JSONDecodingUtility: DecodingUtility {
    func decode<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        let result = try decoder.decode(T.self, from: data)
        
        return result
    }
}
