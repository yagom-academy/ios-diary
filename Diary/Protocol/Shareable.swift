//
//  Shareable.swift
//  Diary
//
//  Created by hoon, karen on 2023/09/11.
//

import UIKit

protocol Shareable {
    associatedtype Contents
    func showActivityView(data: Contents, viewController: UIViewController?)
}

extension Shareable {
    func showActivityView(data: Contents, viewController: UIViewController?) {
        var shareObject = [Contents]()
        
        shareObject.append(data)
        
        let activityViewController = UIActivityViewController(activityItems: shareObject, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = viewController?.view
        viewController?.present(activityViewController, animated: true)
    }
}
