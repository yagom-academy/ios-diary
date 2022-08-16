//
//  JSONData.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/16.
//

import UIKit
import Foundation

struct JSONData {
    static func parse<T: Decodable>(name: String) -> T? {
        let jsonDecoder: JSONDecoder = JSONDecoder()

        guard let dataAsset: NSDataAsset = NSDataAsset(name: name) else {
            return nil
        }

        do {
            let data = try jsonDecoder.decode(T.self, from: dataAsset.data)
            return data
        } catch(let error) {
            print(error)
            return nil
        }
    }
}
