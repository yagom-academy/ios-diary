//
//  SpyDiaryContentViewModel.swift
//  Diary
//
//  Created by Derrick kim on 2022/08/29.
//

import Foundation

final class SpyDiaryContentViewModel: DiaryViewModelLogic {
    var spyDiaryContents = [DiaryContent]()
    
    var saveCalled: Int = 0
    
    var fetchCalled: Int = 0
    
    var updateCalled: Int = 0
    
    var removeCalled: Int = 0
    
    var createdAt = Date()
    
    func save(_ text: String, _ date: Date) {
        saveCalled += 1
        
        spyDiaryContents.append(convertToDiaryContent(text, date))
    }
    
    func fetch() {
        fetchCalled += 1
    }
    
    func update(_ text: String) {
        updateCalled += 1
        spyDiaryContents.append(convertToDiaryContent(text, createdAt))
    }
    
    func remove() {
        removeCalled += 1
        spyDiaryContents.removeLast()
    }
    
    private func convertToDiaryContent(_ text: String, _ date: Date) -> DiaryContent {
        var data = text.split(separator: Character(Const.nextLineString), maxSplits: 2).map{ String($0) }
        let title = data.remove(at: 0)
        let body = data.count >= 1 ? data.joined(separator: String(Const.nextLineString)) : Const.emptyString
        
        return DiaryContent(title: title, body: body, createdAt: date)
    }
}
