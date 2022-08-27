//
//  DiaryContentViewModel.swift
//  Diary
//
//  Created by Hugh,Derrick kim on 2022/08/27.
//

import Foundation

final class DiaryContentViewModel: DiaryViewModelLogic {
    var createdAt: Date?
    
    var diaryContents: [DiaryContent]? {
        didSet{
            self.reloadTableViewClosure?()
        }
    }
    
    var alertMessage: String? {
        didSet{
            self.showAlertClosure?()
        }
    }
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    private var dataManager: DataManageLogic?
    
    init() {
        dataManager = CoreDataManager()
        fetch()
    }
    
    func save(_ text: String, _ date: Date) {
        let data = convertToDiaryContent(text, date)
        do {
            try dataManager?.save(data: data)
        } catch CoreDataError.noneEntity {
            self.alertMessage = CoreDataError.noneEntity.message
        } catch {
            self.alertMessage = CoreDataError.fetchFailure.message
        }
    }
    
    func fetch() {
        do {
            diaryContents = try dataManager?.fetch()
        } catch CoreDataError.fetchFailure {
            self.alertMessage = CoreDataError.fetchFailure.message
        } catch {
            self.alertMessage = CoreDataError.noneEntity.message
        }
    }
    
    func update(_ text: String) {
        guard let date = createdAt else {
            return
        }
        
        let data = convertToDiaryContent(text, date)
        do {
            try dataManager?.update(data: data)
        } catch CoreDataError.fetchFailure {
            self.alertMessage = CoreDataError.fetchFailure.message
        } catch {
            self.alertMessage = CoreDataError.noneEntity.message
        }
    }
    
    func remove() {
        guard let date = createdAt else {
            return
        }
        
        do {
            try dataManager?.remove(date: date)
            fetch()
        } catch CoreDataError.fetchFailure {
            self.alertMessage = CoreDataError.fetchFailure.message
        } catch {
            self.alertMessage = CoreDataError.noneEntity.message
        }
    }
    
    private func convertToDiaryContent(_ text: String, _ date: Date) -> DiaryContent {
        var data = text.split(separator: Character(Const.nextLineString), maxSplits: 2).map{ String($0) }
        let title = data.remove(at: 0)
        let body = data.count >= 1 ? data.joined(separator: String(Const.nextLineString)) : Const.emptyString
        
        return DiaryContent(title: title, body: body, createdAt: date)
    }
}
