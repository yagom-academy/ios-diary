//
//  DiaryManger.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/08/23.
//

import Foundation

class DiaryManger {
    
    var sampleDiaryContent = [SampleDiaryContent]() {
        didSet {
            NotificationCenter.default.post(name: .mockdataUpload, object: self)
        }
    }
    
    func loadData() {
        guard let data: [SampleDiaryContent]? = JSONDecoder.decodedJson(jsonName: "sample"),
              let data = data else {
            return
        }
        self.sampleDiaryContent = data
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: .mockdataUpload,
                                                  object: nil)
    }
}
