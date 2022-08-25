//
//  DiaryViewModel.swift
//  Diary
//  Created by Hugh,Derrick kim on 2022/08/17.
//

import Foundation

final class DiaryViewModel {
    var diaryContent: DiaryContent? {
        didSet {
            NotificationCenter.default.post(name: .diaryContent, object: self)
        }
    }

    private let coreDataManager = CoreDataManager()

    init(data: DiaryContent) {
        self.diaryContent = data
    }
    
    init() {}
    
    var titleText: String? {
        guard let diaryContent = diaryContent else {
            return nil
        }
        
        return diaryContent.title
    }
    
    var shortDescriptionText: String? {
        guard let diaryContent = diaryContent else {
            return nil
        }
        
        return diaryContent.body
    }
    
    var dateText: String? {
        guard let diaryContent = diaryContent else {
            return nil
        }
        
        return diaryContent.createdAt.formattedDate
    }
    
    var longDescriptionText: String? {
        guard let diaryContent = diaryContent else {
            return nil
        }
        
        return diaryContent.title + "\n\n" + diaryContent.body
    }
    
    var diaryContents: [DiaryContent] {
        guard let contents = fetchData() else {
            return [DiaryContent]()
        }

        return contents
    }
    
    private func fetchData() -> [DiaryContent]? {
        guard let data = coreDataManager.fetchContext() as? [DiaryEntity] else {
            return nil
        }
        
        var diaryContentArray = [DiaryContent]()
        
        data.forEach { data in
            guard let title = data.title,
                  let body = data.body else {
                return
            }
            
            diaryContentArray.append(DiaryContent(title: title,
                                                  body: body,
                                                  createdAt: data.createdAt))
        }

        return diaryContentArray
    }
    
    func assign(text: String, date: Double) {
        guard text != "" else {
            return
        }
        
        self.diaryContent = convertToDiaryContent(text, date)
        
        guard let diaryContent = diaryContent else {
            return
        }
        
        coreDataManager.insertContext(data: diaryContent)
    }
    
    func delete(_ title:String) {
        self.diaryContent = nil
        coreDataManager.deleteContext(title: title)
    }
    
    func update(text: String, date: Double) {
        guard text != "" else {
            return
        }
        
        self.diaryContent = convertToDiaryContent(text, date)
        
        guard let diaryContent = diaryContent else {
            return
        }
        
        coreDataManager.updateContext(data: diaryContent)
    }
    
    private func convertToDiaryContent(_ text: String, _ date: Double) -> DiaryContent {
        var data = text.split(separator: "\n", maxSplits: 2).map{ String($0) }
        let title = data.remove(at: 0)
        let body = data.count >= 1 ? data.joined(separator: "\n") : ""
        
        return DiaryContent(title: title, body: body, createdAt: date)
    }
}

extension Notification.Name {
    static let diaryContent = Notification.Name("DiaryContent")
}
