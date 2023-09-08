//
//  PresentableActivityView.swift
//  Diary
//
//  Created by Mary & Whales on 2023/09/08.
//

import UIKit

protocol PresentableActivityView where Self: UIViewController {
    func presentActivityView(shareItem: String)
}

extension PresentableActivityView {
    func presentActivityView(shareItem: String) {
        let activityViewController = UIActivityViewController(
            activityItems: [shareItem],
            applicationActivities: [])

        present(activityViewController, animated: true)
    }
}
