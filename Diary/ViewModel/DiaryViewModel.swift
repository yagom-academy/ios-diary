//
//  DiaryViewModel.swift
//  Diary
//  Created by Hugh,Derrick kim on 2022/08/17.
//

import Foundation

final class DiaryViewModel {
    private var diaryContent: DiaryContent?
    
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
}
