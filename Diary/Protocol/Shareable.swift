//
//  Shareable.swift
//  Diary
//
//  Created by hoon, karen on 2023/09/11.
//

import UIKit

protocol Shareable {
    func showActivityView(data: Any, viewController: UIViewController)
}

extension Shareable {
    func showActivityView(data: Any, viewController: UIViewController) {
        var shareObject = [Any]()
        
        shareObject.append(data)
        
        let activityViewController = UIActivityViewController(activityItems: shareObject, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = viewController.view
        viewController.present(activityViewController, animated: true)
    }
}
