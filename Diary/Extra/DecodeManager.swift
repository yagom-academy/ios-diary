//
//  DecodeManager.swift
//  Diary
//
//  Created by rilla, songjun on 2023/04/24.
//

import UIKit

final class DecodeManager {
    private let decoder = JSONDecoder()
    
    func decodeJSON<T: Decodable>(fileName: String, type: T.Type) -> Result<T, DecodeError> {
        
        guard let JSONFile: NSDataAsset  = NSDataAsset(name: fileName) else {
            return .failure(.invalidFileError)
        }
        
        do{
            let decodedJSON: T = try decoder.decode(type, from: JSONFile.data)
            return .success(decodedJSON)
        } catch {
            return .failure(.decodingFailureError)
        }
    }
}
