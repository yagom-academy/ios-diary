//
//  Parser.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/20.
//

import UIKit

struct Parser<T: Decodable> {
    func parse(name: String) throws -> [T]? {
        guard let content = NSDataAsset(name: name) else {
            throw DiaryError.invalidFileName
        }
        guard let decodedData: [T] = try? JSONDecoder().decode(
            [T].self, from: content.data
        ) else {
            throw DiaryError.decodeError
        }
        return decodedData
    }
}
