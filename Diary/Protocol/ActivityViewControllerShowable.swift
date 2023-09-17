//
//  ActivityViewControllerShowable.swift
//  Diary
//
//  Created by Zion, Serena on 2023/09/11.
//

import UIKit

protocol ActivityViewControllerShowable where Self: UIViewController {
    func showActivityViewController(items: [Any])
}

extension ActivityViewControllerShowable {
    func showActivityViewController(items: [Any]) {
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        present(activityViewController, animated: true)
    }
}
