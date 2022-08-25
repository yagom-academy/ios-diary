//
//  MockDiaryManager.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/22.
//

import Foundation
import UIKit.NSDataAsset

final class MockDiaryManager: DataManagable {
    typealias Model = Diary
    typealias ModelObject = Diary
    
    // MARK: - properites
    
    private var model = [Diary]() {
        didSet {
            NotificationCenter.default.post(name: .didReceiveData,
                                            object: self,
                                            userInfo: nil)
        }
    }
    
    // MARK: - initializers
    
    init() { }
    
    init(model: [Diary]) {
        self.model = fetch()
    }
    
    // MARK: - functions
    
    func create(model: Diary) {
        
    }
    
    func fetch() -> [Diary] {
        guard let data = NSDataAsset(name: "sample")?.data,
              let decodedData = try? JSONDecoder().decode([Diary].self, from: data)
        else { return [] }
        
        return decodedData
    }
    
    func getModel(by indexPath: IndexPath) -> Diary {
        guard let model = model.get(index: indexPath.row)
        else { return Diary(uuid: UUID(), title: "", body: "", createdAt: 0.0) }
        
        return model
    }
    
    func update(model diary: Diary) {
        
        model.append(diary)
    }
    
    func delete(_ id: UUID) {
        model = model.filter { $0.uuid != id }
    }
    
    func deleteAll() {
        model.removeAll()
    }
}
