//
//  DiaryContentViewModel.swift
//  Diary
//
//  Created by Hugh,Derrick kim on 2022/08/27.
//

import Foundation

protocol DiaryViewModelLogic {
    func save(_ data: DiaryContent)
    func fetch()
    func update(_ data: DiaryContent)
    func remove(_ date: Date)
}

final class DiaryContentViewModel: DiaryViewModelLogic {
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
  
    func save(_ data: DiaryContent) {
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

    func update(_ data: DiaryContent) {
        do {
            try dataManager?.update(data: data)
        } catch CoreDataError.fetchFailure {
            self.alertMessage = CoreDataError.fetchFailure.message
        } catch {
            self.alertMessage = CoreDataError.noneEntity.message
        }
    }
    
    func remove(_ date: Date) {
        do {
            try dataManager?.remove(date: date)
        } catch CoreDataError.fetchFailure {
            self.alertMessage = CoreDataError.fetchFailure.message
        } catch {
            self.alertMessage = CoreDataError.noneEntity.message
        }
    }
}
