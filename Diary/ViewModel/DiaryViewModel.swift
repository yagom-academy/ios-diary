//
//  DiaryViewModel.swift
//  Diary
//  Created by Hugh,Derrick kim on 2022/08/17.
//

import Foundation

final class DiaryViewModel {
    private var diaryContent: DiaryContent?
    private let jsonManager = JSONManager()
    
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
        let fileName = "diarySample"
        let result = jsonManager.checkFileAndDecode(dataType: [DiaryContent].self, fileName)
        
        switch result {
        case .success(let contents):
            return contents
        default:
            return nil
        }
    }
}
