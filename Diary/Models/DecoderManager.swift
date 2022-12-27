//
//  DecoderManager.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/19.
//

import UIKit

struct DecoderManager<T: Decodable> {
    let decoder = JSONDecoder()
    
    func decodeJsonData(_ fileName: String) -> Result<[T], DataError> {
        guard let assetsData = NSDataAsset(name: fileName) else {
            return Result.failure(.noneDataError)
        }
        guard let data = try? decoder.decode([T].self, from: assetsData.data) else {
            return Result.failure(.decodeError)
        }
        
        return Result.success(data)
    }
}
