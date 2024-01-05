//
//  JsonDecoder.swift
//  Diary
//
//  Created by Hisop on 2024/01/05.
//

import UIKit

struct JsonDecoder {
     func decodeSampleData() -> [Diary] {
        guard let dataAsset = NSDataAsset(name: "sample") else {
            return []
        }
        
        let decoder = JSONDecoder()
        var diaryData: [Diary] = []
         
        do {
            diaryData = try decoder.decode(
                [Diary].self,
                from: dataAsset.data
            )
        } catch {
            print(error.localizedDescription)
        }
         
        return diaryData
    }
}
