//
//  ActivityViewPresentable.swift
//  Diary
//
//  Created by Mary & Whales on 2023/09/08.
//

import UIKit

protocol ActivityViewPresentable where Self: UIViewController {
    func presentActivityView(shareItem: String)
}

extension ActivityViewPresentable {
    func presentActivityView(shareItem: String) {
        let activityViewController = UIActivityViewController(
            activityItems: [shareItem],
            applicationActivities: [])

        present(activityViewController, animated: true)
    }
}
