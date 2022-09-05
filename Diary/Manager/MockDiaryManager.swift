//
//  MockDiaryManager.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/22.
//

import Foundation
import UIKit.NSDataAsset

final class MockDiaryManager: DiaryManagable {
    // MARK: - properites
    
    private var model = [Diary]() {
        didSet {
            NotificationCenter.default.post(name: .didReceiveData,
                                            object: self,
                                            userInfo: nil)
        }
    }
    
    var diaryList: [Diary] = []
    var newDiary: Diary?
    
    // MARK: - initializers
    
    init() {
        fetch()
    }
    
    // MARK: - functions
    
    func fetch() {
        guard let data = NSDataAsset(name: "sample")?.data,
              let decodedData = try? JSONDecoder().decode([Diary].self, from: data)
        else { return }
        
        diaryList = decodedData
    }
    
    func create(_ model: Diary) {
        newDiary = model
    }
    
    func getModel(by indexPath: IndexPath) -> Diary {
        guard let model = model.get(index: indexPath.row)
        else { return Diary(uuid: UUID(), title: "", body: "", createdAt: 0.0, icon: "") }
        
        return model
    }
    
    func update(_ diary: Diary) {
        model.append(diary)
    }
    
    func delete(_ diary: Diary) {
        model.removeFirst()
    }
    
    func deleteAll() {
        model.removeAll()
    }
}
