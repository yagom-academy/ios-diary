//
//  SpyDiaryContentViewModel.swift
//  Diary
//
//  Created by Derrick kim on 2022/08/29.
//

import Foundation

final class SpyDiaryContentViewModel: DiaryViewModelLogic {
    var createdAt: Date?
    var diaryContents: [DiaryContent]?
    var alertMessage: String?
    var reloadTableViewClosure: (() -> ())?
    var showAlertClosure: (() -> ())?
    var requestUIImage: ((String) -> ())?
    
    var saveCalled: Int = 0
    var fetchCalled: Int = 0
    var updateCalled: Int = 0
    var removeCalled: Int = 0
    
    func save(_ text: String, _ date: Date) {
        saveCalled += 1
        
        diaryContents?.append(convertToDiaryContent(text, date))
    }
    
    func fetch() {
        fetchCalled += 1
    }
    
    func update(_ text: String) {
        updateCalled += 1
        diaryContents?.append(convertToDiaryContent(text, createdAt!))
    }
    
    func remove() {
        removeCalled += 1
        diaryContents?.removeLast()
    }
    
    func fetchWeatherData() {
        
    }
    
    func requestLocation(_ latitude: Double, with longitude: Double) {
        
    }
    
    private func convertToDiaryContent(_ text: String, _ date: Date) -> DiaryContent {
        var data = text.split(separator: Character(Const.nextLineString), maxSplits: 2).map{ String($0) }
        let title = data.remove(at: 0)
        let body = data.count >= 1 ? data.joined(separator: String(Const.nextLineString)) : Const.emptyString
        
        return DiaryContent(title: title, body: body, createdAt: date)
    }
}
