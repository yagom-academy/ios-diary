//
//  DummyData.swift
//  Diary
//
//  Created by 재재, 그루트 on 2022/08/17.
//

import UIKit

struct DummyData {
    let diaryItems: [DiaryTestData]?

    init?() {
        let data = NSDataAsset(name: "testSample")
        guard let decodedData = try? JSONDecoder().decode([DiaryTestData].self,
                                                          from: data?.data ?? Data()) else { return nil }

        self.diaryItems = decodedData
    }
}
