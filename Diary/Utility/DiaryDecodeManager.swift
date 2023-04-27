//
//  DiarySampleDecoder.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/27.
//

import Foundation

struct DiaryDecodeManager {
    private let jsonDecoder = JSONDecoder()
    
    func decode<T: Decodable>(type: T.Type, data: Data) -> Result<T, Error> {
        let result = Result { try jsonDecoder.decode(type, from: data) }
        
        return result
    }
}
