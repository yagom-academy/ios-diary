//
//  DecodeManager.swift
//  Diary
//
//  Created by rilla, songjun on 2023/04/24.
//

import UIKit

final class DecodeManager {
    private let decoder = JSONDecoder()
    
    func decodeJSON<T: Decodable>(fileName: String, type: T.Type) throws -> T? {
        guard let JSONFile: NSDataAsset  = NSDataAsset(name: fileName) else {
            throw DecodeError.invalidFileError
        }
        
        do {
            let decodedJSON: T = try decoder.decode(type, from: JSONFile.data)
            return decodedJSON
        } catch {
            throw DecodeError.decodingFailureError
        }
    }
}
