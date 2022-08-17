//
//  DiaryListViewModel.swift
//  Diary
//  Created by Hugh,Derrick kim on 2022/08/17.
//

import Foundation

final class DiaryListViewModel {
    private let service = DiaryService()
    
    private let diaryContent: DiaryContent
    
    init(data: DiaryContent) {
        self.diaryContent = data
    }
    
    var titleText: String {
        return diaryContent.title
    }
    
    var shortDescriptionText: String {
        return diaryContent.body
    }
    
    var dateText: String {
        return service.convertToDiaryDate(from: diaryContent.createdAt)
    }
}
