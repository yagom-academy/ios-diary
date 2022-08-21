//
//  JSONManager.swift
//  Diary
//
//  Created by Hugh, Derrick on 2022/08/16.
//

import UIKit

struct JSONManager {
    private var jsonDecoder = JSONDecoder()
    
    func checkFileAndDecode<T: Decodable>(dataType: T.Type, _ fileName: String) -> Result<T, JSONError> {
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            guard let asset = NSDataAsset.init(name: fileName) else {
                return .failure(JSONError.noneFile)
            }
            
            let data = try jsonDecoder.decode(T.self, from: asset.data)
            
            return .success(data)
        } catch {
            return .failure(JSONError.decodingFailure)
        }
    }
}
