//
//  DecodeManager.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/04/26.
//

import UIKit

struct DecodeManager {
    private let jsonDecoder = JSONDecoder()

    func decodeJsonAsset<Element: Decodable>(name: String, type: Element.Type) -> Result<Element, DiaryError> {
        guard let dataAsset = NSDataAsset(name: name) else {
            return .failure(.invalidFile)
        }
        
        do {
            let result = try jsonDecoder.decode(type.self, from: dataAsset.data)
            return .success(result)
        } catch {
            return .failure(.decodingFailed)
        }
    }
    
    func decodeAPI<Element: Decodable>(data: Data, type: Element.Type) -> Result<Element, DiaryError> {
        do {
            let result = try jsonDecoder.decode(type.self, from: data)
            return .success(result)
        } catch {
            return .failure(.decodingFailed)
        }
    }
}
