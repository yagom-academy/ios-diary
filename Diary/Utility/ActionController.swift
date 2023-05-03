//
//  Diary - ActionController.swift
//  Created by Rhode, 무리.
//  Copyright © yagom. All rights reserved.
//

import UIKit

enum ActionController {
    static func showActivityViewController(from viewController: UIViewController) {
        let activityItems = [UIActivity.ActivityType.airDrop, .message, .mail]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = viewController.view
        
        viewController.present(activityViewController, animated: true, completion: nil)
    }
}
