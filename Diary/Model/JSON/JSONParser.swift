//
//  JSONParser.swift
//  Diary
//
//  Created by 백곰, 주디 on 2022/08/16.
//

import UIKit

struct JSONParser {
    func fetch<T: Decodable>(name: String) throws -> [T] {
        let decoder = JSONDecoder()

        guard let sample = NSDataAsset.init(name: name) else {
            throw JSONError.noneFile
        }

        do {
            let diaryList = try decoder.decode([T].self, from: sample.data)
            return diaryList
        } catch {
            throw JSONError.decodingFailure
        }
    }
}
