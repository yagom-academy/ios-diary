//
//  MockDiaryManager.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/22.
//

import Foundation
import UIKit.NSDataAsset

class MockDiaryManager {
    private var model = [Diary]() {
        didSet {
            NotificationCenter.default.post(name: .didReceiveData,
                                            object: self,
                                            userInfo: nil)
        }
    }
    
    init() { }
    
    init(model: [Diary]) {
        self.model = model
    }
    
    func fetch() {
        guard let data = NSDataAsset(name: "sample")?.data,
              let decodedData = try? JSONDecoder().decode([Diary].self, from: data)
        else { return }
        
        self.model = decodedData
    }
    
    func getDiary() -> [Diary] {
        return model
    }
    
    func getModel(by indexPath: IndexPath) -> Diary {
        guard let model = model.get(index: indexPath.row)
        else { return Diary(title: "", body: "", createdAt: 0.0) }
        
        return model
    }
    
    func update(with diary: Diary) {
        fetch()
        model.append(diary)
    }
}
