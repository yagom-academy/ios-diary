//
//  DecodeManager.swift
//  Diary
//
//  Created by Jinah Park on 2023/05/11.
//

import UIKit

final class DecodeManager {
    static let shared = DecodeManager()
    private let decoder = JSONDecoder()
    
    private init() { }
    
    func decodeJSON<T: Decodable>(data: Data, type: T.Type) -> Result<T, DecodeError> {
        
        guard let decodedJSON: T = try? decoder.decode(type, from: data) else { return .failure(.decodingFailureError) }
        
        return .success(decodedJSON)
    }
}
