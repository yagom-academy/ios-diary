//
//  SampleDataManager.swift
//  Diary
//
//  Created by Toy, Morgan on 1/3/24.
//

import UIKit

struct SampleDataManager {
    func generateDiaryData<T: Decodable>(asset: String, type: [T].Type) -> [T]? {
        guard let asset = NSDataAsset(name: asset) else { return nil }
        
        let jsonDecoder = JSONDecoder()
        
        do {
            let data = try jsonDecoder.decode(type.self, from: asset.data)
            return data
        } catch {
            print(error)
            return nil
        }
    }
}
