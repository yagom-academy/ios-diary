//
//  DiaryViewModel.swift
//  Diary
//  Created by Hugh,Derrick kim on 2022/08/17.
//

import Foundation

final class DiaryViewModel {
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
        return diaryContent.createdAt.formattedDate
    }
    
    var longDescriptionText: String {
        return diaryContent.title + "\n\n" + diaryContent.body
    }
}
