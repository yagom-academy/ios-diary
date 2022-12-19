//
//  DecoderManager.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/19.
//

import UIKit

struct DecoderManager {
    let decoder = JSONDecoder()
    
    func decodeJsonData(_ fileName: String) -> Result<Diary, DataError> {
        guard let assetsData = NSDataAsset(name: fileName) else {
            return Result.failure(.nonDataError)
        }
        guard let data = try? decoder.decode(Diary.self, from: assetsData.data) else {
            return Result.failure(.decodeError)
        }
        
        return Result.success(data)
    }
}
