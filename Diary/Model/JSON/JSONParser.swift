//
//  JSONParser.swift
//  Diary
//
//  Created by 백곰, 주디 on 2022/08/16.
//

import UIKit

struct JSONParser {
    func fetch(name: String) throws -> [DiaryItem] {
        let decoder = JSONDecoder()
        
        guard let sample = NSDataAsset.init(name: name) else {
            throw JSONError.noneFile
        }
        
        do {
            let diaryList = try decoder.decode([DiaryItem].self, from: sample.data)
            return diaryList
        } catch {
            throw JSONError.decodingFailure
        }
    }
}
