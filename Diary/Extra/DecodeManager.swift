//
//  DecodeManager.swift
//  Diary
//
//  Created by rilla, songjun on 2023/04/24.
//

import UIKit

final class DecodeManager {
    private enum DecodeError: LocalizedError {
        case invalidFileError
        case decodingFailureError
        
        var errorDescription: String? {
            switch self {
            case .invalidFileError:
                return "해당 file이 존재하지 않습니다."
            case .decodingFailureError:
                return "해당 file을 디코딩할 수 없습니다."
            }
        }
    }
    
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
