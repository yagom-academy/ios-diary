//
//  DiaryViewModel.swift
//  Diary
//  Created by Hugh,Derrick kim on 2022/08/17.
//
//
//import Foundation
//
//final class DiaryViewModel {
//    var alertMessage: String? {
//        didSet{
//            // notify
//            self.showAlertClosure?()
//        }
//    }
//    
//    var reloadTableViewClosure: (()->())?
//    var showAlertClosure: (()->())?
//
//    private let dataManager: DataManageLogic?
//    
//    init(data: DiaryContent) {
//        dataManager = CoreDataManager()
//    }
//    
//    init() {}
//    
//    var titleText: String? {
//        return diaryContent.title
//    }
//    
//    var shortDescriptionText: String? {
//        return diaryContent.body
//    }
//    
//    var dateText: String? {
//        return diaryContent.createdAt.formattedDate
//    }
//    
//    var longDescriptionText: String? {
//        return diaryContent.title + "\n\n" + diaryContent.body
//    }
//    
//    var diaryContents: [DiaryContent] {
//        didSet{
//            self.reloadTableViewClosure?()
//        }
//    }
//    
//    func fetchDiaryContents(at indexPath: IndexPath) -> DiaryContent {
//        return diaryContents[indexPath.row]
//    }
//    
//    func save(text: String, date: Date) {
//        guard text != "" else {
//            return
//        }
//        do {
//            try dataManager?.save(data: convertToDiaryContent(text, date))
//        } catch {
//            self.alertMessage = ""
//        }
//    }
//    
//    func remove(date:Date) throws {
//        do {
//            try dataManager?.remove(date: date)
//        } catch (let error) {
//            self.alertMessage = error.message
//        }
//    }
//    
//    func update(text: String, date: Date) {
//        guard text != "" else {
//            return
//        }
//        do {
//            try dataManager?.update(data: convertToDiaryContent(text, date))
//        } catch {
//            self.alertMessage = ""
//        }
//    }
//    
//    private func convertToDiaryContent(_ text: String, _ date: Date) -> DiaryContent {
//        var data = text.split(separator: "\n", maxSplits: 2).map{ String($0) }
//        let title = data.remove(at: 0)
//        let body = data.count >= 1 ? data.joined(separator: "\n") : ""
//        
//        return DiaryContent(title: title, body: body, createdAt: date)
//    }
//}
