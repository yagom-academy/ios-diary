//
//  Diary - DiaryDataDecoder.swift
//  Created by Rhode, 무리.
//  Copyright © yagom. All rights reserved.
//

import UIKit

struct DiaryDataDecoder {
    let jsonDecoder: JSONDecoder = JSONDecoder()

    func decodeDiaryData() -> [Diary]? {
        guard let dataAsset = NSDataAsset(name: "Data") else { return nil }
        
        do {
            let diary = try jsonDecoder.decode([Diary].self, from: dataAsset.data)
            
            return diary
        } catch {
            print(error.localizedDescription)
            
            return nil
        }
    }
}
