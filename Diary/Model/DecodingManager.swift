//
//  DecodingManager.swift
//  Diary
//
//  Created by Maxhyunm, Hamg on 2023/08/30.
//

import UIKit

final class DecodingManager {
    static func decodeJson<T: Decodable>(from dataAssetName: String) -> T? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
 
        guard let dataAsset = NSDataAsset(name: dataAssetName),
              let decodedData = try? decoder.decode(T.self, from: dataAsset.data) else {
            return nil
        }
        
        return decodedData
    }
}
