//
//  JSONParser.swift
//  Diary
//
//  Created by 백곰, 주디 on 2022/08/16.
//

import UIKit

class JSONManager: DataManageable {
    func saveDiary(item: DiaryItem) { }
    
    func deleteDiary(id: UUID) { }
    
    func fetchDiary() -> [DiaryItem]? {
        let decoder = JSONDecoder()

        guard let sample = NSDataAsset.init(name: "sample") else { return nil }

        do {
            let JSONList = try decoder.decode([JSONDiary].self, from: sample.data)
            let diaryList = JSONList.map {
                DiaryItem(id: UUID(), title: $0.title, body: $0.body, createdAt: $0.createdAt)
            }
            
            return diaryList
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}
