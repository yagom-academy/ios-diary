//
//  DecoderManager.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/19.
//

import UIKit

struct DecoderManager<T: Decodable> {
    let decoder = JSONDecoder()
    
    func decodeData(_ data: Data) -> Result<T, SessionError> {
        guard let data = try? decoder.decode(T.self, from: data) else {
            return Result.failure(.decodeError)
        }
        
        return Result.success(data)
    }
}
