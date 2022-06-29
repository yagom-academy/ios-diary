//
//  Decodable+.swift
//  Diary
//
//  Created by dudu, papri on 2022/06/29.
//

import Foundation

extension Decodable {
    static func parse(_ data: Data) -> Self? {
        return try? JSONDecoder().decode(Self.self, from: data)
    }
}
