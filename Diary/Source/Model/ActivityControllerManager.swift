//
//  ActivityControllerManager.swift
//  Diary
//  Created by inho, dragon on 2022/12/28.
//

import UIKit

struct ActivityControllerManager {
    func showActivity(textToShare: String) -> UIActivityViewController {
        let activity = UIActivityViewController(activityItems: [textToShare],
                                                applicationActivities: nil)
        
        return activity
    }
}
