//
//  Decoder.swift
//  Diary
//
//  Created by 리지, Goat on 2023/04/24.
//

import UIKit

enum Decoder {
    static func parseJSON<Element: Decodable>(fileName: String, returnType: Element.Type) throws -> Element? {
        let jsonDecoder = JSONDecoder()
        guard let dataAsset = NSDataAsset(name: fileName) else { return nil }
        
        do {
            let result = try jsonDecoder.decode(returnType, from: dataAsset.data)
            
            return result
        } catch {
            throw DiaryError.decodeFailure
        }
    }
    
    static func parseJSON<Element: Decodable>(data: Data, returnType: Element.Type) throws -> Element? {
        let jsonDecoder = JSONDecoder()
        
        do {
            let result = try jsonDecoder.decode(returnType, from: data)
            
            return result
        } catch {
            throw DiaryError.decodeFailure
        }
    }
}
