//
//  ActivityPresentable.swift
//  Diary
//  Created by inho, dragon on 2022/12/28.
//

import UIKit

protocol ActivityPresentable: UIViewController {
    func presentActivity(textToShare: String)
}

extension ActivityPresentable {
    func presentActivity(textToShare: String) {
        let activity = UIActivityViewController(
            activityItems: [textToShare],
            applicationActivities: nil
        )
        
        present(activity, animated: true, completion: nil)
    }
}
