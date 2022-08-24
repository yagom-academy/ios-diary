//
//  JSONDecoder + Extension.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/08/16.
//

import Foundation

extension JSONDecoder {
    static func decodedJson<T: Decodable>(jsonName: String) -> T? {
        let decoder = JSONDecoder()
        guard let fileLocation = Bundle.main.url(forResource: jsonName, withExtension: "json") else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileLocation)
            let sampleDiary = try decoder.decode(T.self, from: data)
            return sampleDiary
        } catch {
            print(error)
            return nil
        }
    }
}
