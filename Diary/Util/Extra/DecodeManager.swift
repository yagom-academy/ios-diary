//
//  DecodeManager.swift
//  Diary
//
//  Created by rilla, songjun on 2023/05/09.
//

import Foundation

struct DecodeManager {
    func decode<T: Decodable>(data: Data, type: T.Type) -> T? {
        var decodingResult: T?
        let jsonDecoder = JSONDecoder()
        
        do {
            decodingResult = try jsonDecoder.decode(T.self, from: data)
            return decodingResult
        } catch {
            print("에러 : decode 안됨")
            return nil
        }
    }
}
