//
//  ActivityViewManager.swift
//  Diary
//
//  Created by Christy, vetto on 2023/05/05.
//

import UIKit

struct ActivityViewManager {
    func showActivityView(target: UIViewController) {
        let shareText: String = "share text test!"
        var shareObject = [Any]()
        
        shareObject.append(shareText)
        
        let activityViewController = UIActivityViewController(activityItems: shareObject,
                                                              applicationActivities: nil)
        
        target.present(activityViewController, animated: true)
    }
}
