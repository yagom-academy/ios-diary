//
//  DataManager.swift
//  Diary
//
//  Created by 민쏜, 보리사랑 on 2022/08/17.
//

import UIKit

struct DiaryDataManager {
    
    // MARK: - Properties
    
    let temporarySampleData = NSDataAsset.init(name: "sample modify")
    
    // MARK: - Methods
    
    func parse<T: Decodable>(_ data: Data, into type: T.Type) -> T? {
        
        let jsonDecoder = JSONDecoder()
        
        do {
            let decodedData = try jsonDecoder.decode(T.self, from: temporarySampleData!.data)
            return decodedData
        } catch {
            print("Unexpected error: \(error)")
            return nil
        }
    }
}
