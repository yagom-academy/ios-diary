//
//  NetworkingProvider.swift
//  Diary
//
//  Created by dhoney96 on 2022/08/16.
//

import UIKit

struct NetworkingProvider {
    func requestAndDecode<T: Decodable>(_ fileName: String, dataType: T.Type) -> Result<T, JSONError>? {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            guard let asset = NSDataAsset.init(name: fileName) else {
                return .failure(JSONError.noneFile)
            }
            return .success(try jsonDecoder.decode(T.self, from: asset.data))
        } catch {
            return .failure(JSONError.decodingFailure)
        }
    }
}
