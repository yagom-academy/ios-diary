//
//  Decodable+.swift
//  Diary
//
//  Created by 김태현 on 2022/06/13.
//

import Foundation

extension Decodable {
    static func parse(data: Data) -> [Self]? {
        guard let data = try? Json.shared.decode([Self].self, from: data) else {
            return nil
        }
        
        return data
    }
}

final class Json {
    static let shared = JSONDecoder()
    
    private init() { }
}
