//
//  MyActivityItemSource.swift
//  Diary
//
//  Created by unchain, 웡빙 on 2022/08/24.
//

import LinkPresentation

final class MyActivityItemSource: NSObject, UIActivityItemSource {
    var title: String
    var body: String
    
    init(title: String, text: String) {
        self.title = title
        self.body = text
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return body
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return body
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return title
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        metadata.iconProvider = NSItemProvider(object: UIImage(systemName: "doc.text")!)
        metadata.originalURL = URL(fileURLWithPath: body)
        return metadata
    }
}
