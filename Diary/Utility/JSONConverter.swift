//
//  JSONConverter.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2023/01/04.
//

import UIKit

final class JSONConverter {
    static let shared = JSONConverter()
    
    private init() {}
    
    func decodeData<T: Decodable>(data: Data) -> T? {
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch DecodingError.dataCorrupted(let context) {
            print(context.codingPath, context.debugDescription, context.underlyingError ?? "", separator: "\n")
            return nil
        } catch {
            return nil
        }
    }
}
