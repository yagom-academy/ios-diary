//
//  DecodingManager.swift
//  Diary
//
//  Created by Maxhyunm, Hamg on 2023/08/30.
//

import UIKit

final class DecodingManager {
    static func decodeData<T: Decodable>(from data: Data) throws -> T {
        let decoder = JSONDecoder()
       
        guard let decodedData = try? decoder.decode(T.self, from: data) else {
            throw DecodingError.decodingFailure
        }
        
        return decodedData
    }
}
