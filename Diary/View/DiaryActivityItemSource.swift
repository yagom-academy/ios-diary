//
//  DiaryActivityItemSource.swift
//  Diary
//
//  Created by MINT, BMO on 2023/09/08.
//

import LinkPresentation

class DiaryActivityItemSource: NSObject, UIActivityItemSource {
    let diary: DiaryEntity
    
    init(diary: DiaryEntity) {
        self.diary = diary
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return diary.title
    }
    
    func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.configureDiaryDateFormat()
        
        let formattedDate = dateFormatter.string(from: diary.date)
        let sharedData = "\(formattedDate)\n\n\(diary.title)\n\n\(diary.body ?? "")"
        
        return sharedData
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        
        metadata.title = diary.title
        metadata.originalURL = URL(fileURLWithPath: (diary.body ?? ""))
        
        return metadata
    }
}
