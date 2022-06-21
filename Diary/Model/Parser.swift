//
//  Parser.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/20.
//

import UIKit

struct Parser {
    func parse() throws -> [DiaryModel] {
        
        guard let content = NSDataAsset(name: "sample") else {
            throw DiaryError.invalidFileName
        }
        
        guard let decodedData = try? JSONDecoder().decode(
            [DiaryModel].self, from: content.data
        ) else {
            throw DiaryError.decodeError
        }
        
        return decodedData
    }
}
