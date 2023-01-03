//
//  DiaryItemManager.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/28.
//

import Foundation

final class DiaryItemManager {
    static let shared = DiaryItemManager()
    private init() { }
    
    func create() -> DiaryModel {
        let date = Date()
        CoreDataManager.shared.insertDiary(date: date)
        let id = CoreDataManager.shared.fetchID(date: date)
        return DiaryModel(id: id, title: Namespace.empty, body: Namespace.empty, createdAt: date)
    }
    
    func update(diaryItem: DiaryModel?) {
        if isValid(diaryItem) == false { return }
        CoreDataManager.shared.update(diaryItem)
    }
    
    func validate(diaryItem: DiaryModel?) {
        if isValid(diaryItem) == false {
            deleteDiary(data: diaryItem)
            return
        }
        CoreDataManager.shared.update(diaryItem)
    }
    
    private func isValid(_ diaryItem: DiaryModel?) -> Bool {
        return isTitleValid(diaryItem?.title) && isBodyValid(diaryItem?.body)
    }
    
    private func isTitleValid(_ title: String?) -> Bool {
        return title != Placeholder.title && title != Namespace.empty
    }
    
    private func isBodyValid(_ body: String?) -> Bool {
        return body != Placeholder.body && body != Namespace.empty
    }
    
    func createDiaryShareForm(diaryItem: DiaryModel?) -> String {
        guard let diaryItem = diaryItem else { return Namespace.empty }
        
        let form: String = """
            title: \(diaryItem.title)
            body: \(diaryItem.body)
            created at: \(diaryItem.createdAt)
            """

        return form
    }
    
    func deleteDiary(data: DiaryModel?) {
        CoreDataManager.shared.deleteDiary(with: data?.id)
    }
}
