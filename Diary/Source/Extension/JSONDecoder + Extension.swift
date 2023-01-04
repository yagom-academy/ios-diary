//
//  JSONDecoder + Extension.swift
//  Diary
//  Created by inho, dragon on 2023/01/04.
//

import Foundation

extension JSONDecoder {
    static func decodeData<T: Decodable>(data: Data, to type: T.Type) -> T? {
        let decoder = JSONDecoder()
        var decodedData: T?
        
        do {
            decodedData = try decoder.decode(T.self, from: data)
        } catch {
            print(error.localizedDescription)
        }
        
        return decodedData
    }
}
