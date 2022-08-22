//
//  DiaryViewModel.swift
//  Diary
//  Created by Hugh,Derrick kim on 2022/08/17.
//

import Foundation

final class DiaryViewModel {
    private var diaryContent: DiaryContent? {
        didSet {
            NotificationCenter.default.post(name: .diaryContent, object: self)
        }
    }
    
    private let coreDataManager = CoreDataManager()
    private let manager = CoreDataManager()

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
    
    func assign(to data: DiaryContent) {
        diaryContent = data
        manager.insertContext(data: data)
    }
}

extension Notification.Name {
    static let diaryContent = Notification.Name("DiaryContent")
}
