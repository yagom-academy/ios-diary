//
//  DiaryActivityItemSource.swift
//  Diary
//
//  Created by 리지, goat on 2023/05/03.
//

import UIKit
import LinkPresentation

final class DiaryActivityItemSource: NSObject, UIActivityItemSource {
    var title: String
    var body: String
    
    init(title: String, body: String) {
        self.title = title
        self.body = body
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return title
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return body
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return title
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        
        guard let image = UIImage(systemName: "note.text") else { return LPLinkMetadata() }
        metadata.title = title + "\n" + body
        metadata.iconProvider = NSItemProvider(object: image)
        
        return metadata
    }
}
