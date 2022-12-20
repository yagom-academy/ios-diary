//
//  DecodeManager.swift
//  Diary
//
//  Created by 임지연 on 2022/12/20.
//

import UIKit

final class DecodeManager {
    
    static func decodeDiaryData(_ data: Data) -> [Diary]? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let decodedData = try decoder.decode([Diary].self, from: data)
            return decodedData
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
            return nil
        } catch let DecodingError.keyNotFound(_, context) {
            print("Key '(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return nil
        } catch let DecodingError.valueNotFound(_, context) {
            print("Value '(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return nil
        } catch let DecodingError.typeMismatch(_, context) {
            print("Type '(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return nil
        } catch {
            print("error: ", error)
            return nil
        }
    }
}
