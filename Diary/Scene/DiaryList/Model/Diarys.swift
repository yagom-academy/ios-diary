//
//  Diarys.swift
//  Diary
//
//  Created by 이은찬 on 2022/08/22.
//

import Foundation
import UIKit.NSDataAsset

struct Diarys {
    var diary = [DiaryModel]() {
        didSet {
            NotificationCenter.default.post(name: .didReceiveData, object: nil, userInfo: ["diary": diary])
        }
    }
    
    init() {
        self.diary = fetch()
    }
    
    private func fetch() -> [DiaryModel] {
        guard let data = NSDataAsset(name: "sample")?.data,
              let decodedData = try? JSONDecoder().decode([DiaryModel].self, from: data)
        else { return [] }
        
        return decodedData
    }
}
