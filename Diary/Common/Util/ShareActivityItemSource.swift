//
//  ShareActivityItemSource.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/17.
//

import LinkPresentation

fileprivate extension AppConstants {
    static let shareIconImage = "person.circle"
}

final class ShareActivityItemSource: NSObject, UIActivityItemSource {
    private var title: String
    private let text: String
    
    init(title: String, text: String) {
        self.title = title
        self.text = text
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return text
    }
    
    func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        return text
    }
    
    func activityViewController(
        _ activityViewController: UIActivityViewController,
        subjectForActivityType activityType: UIActivity.ActivityType?
    ) -> String {
        return title
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        guard let icon = UIImage(systemName: AppConstants.shareIconImage) else {
            return nil
        }
        let metadata = LPLinkMetadata()
        self.setTitleIfEmpty()
        metadata.title = title
        metadata.iconProvider = NSItemProvider(object: icon)
        metadata.originalURL = URL(fileURLWithPath: text)
        return metadata
    }
    
    private func setTitleIfEmpty() {
        if title.isEmpty {
            self.title = AppConstants.noTitle
        }
    }
}
