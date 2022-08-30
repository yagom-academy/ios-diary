//
//  DiaryViewModelLogic.swift
//  Diary
//
//  Created by Hugh,Derrick kim on 2022/08/27.
//

import Foundation

protocol DiaryViewModelLogic {
    func save(_ text: String, _ date: Date)
    func fetch()
    func update(_ text: String)
    func remove()
    func fetchWeatherData()
    func requestLocation(_ latitude: Double, with longitude: Double)
    
    var diaryContents: [DiaryContent]? { get set }
    var createdAt: Date? { get set }
    var alertMessage: String? { get set }
    var reloadTableViewClosure: (()->())? { get set }
    var showAlertClosure: (()->())? { get set }
}
