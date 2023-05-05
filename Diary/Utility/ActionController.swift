//
//  Diary - ActionController.swift
//  Created by Rhode, 무리.
//  Copyright © yagom. All rights reserved.
//

import UIKit

enum ActionController {
    static func showActivityViewController(from viewController: UIViewController,
                                           title: String, body: String) {
        let activityItems = [title, body]
        let activityViewController = UIActivityViewController(activityItems: activityItems,
                                                              applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = viewController.view
        
        viewController.present(activityViewController, animated: true, completion: nil)
    }
}
