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
    var fetchIconURL: ((String) -> ())?
    
    var saveCalled: Int = 0
    var fetchCalled: Int = 0
    var updateCalled: Int = 0
    var removeCalled: Int = 0
    
    func save(_ text: String, _ date: Date) {
        saveCalled += 1
    }
    
    func fetch() {
        fetchCalled += 1
    }
    
    func update(_ text: String) {
        updateCalled += 1
    }
    
    func remove() {
        removeCalled += 1
        diaryContents?.removeLast()
    }
    
    func fetchWeatherData() {
        
    }
    
    func requestLocation(_ latitude: Double, with longitude: Double) {
        
    }
}
