//
//  JSONData.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/16.
//

import UIKit

struct JSONData {
    static func parse<T: Decodable>(name: String) -> Result<T, Error> {
        let jsonDecoder: JSONDecoder = JSONDecoder()

        guard let dataAsset: NSDataAsset = NSDataAsset(name: name) else {
            return .failure(ParsingError.invalidDataAsset)
        }

        do {
            let data = try jsonDecoder.decode(T.self,
                                              from: dataAsset.data)
            return .success(data)
        } catch(let error) {
            return .failure(error)
        }
    }
}
