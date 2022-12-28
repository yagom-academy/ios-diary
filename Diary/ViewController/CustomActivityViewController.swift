//
//  CustomActivityViewController.swift
//  Diary
//
//  Created by 맹선아 on 2022/12/28.
//

import UIKit

class CustomActivityViewController: UIActivityViewController {

    convenience init(activityItems: [String]) {
        self.init(activityItems: activityItems, applicationActivities: nil)
        excludedActivityTypes = [UIActivity.ActivityType.postToFlickr,
                                 UIActivity.ActivityType.saveToCameraRoll,
                                 UIActivity.ActivityType.postToVimeo,
                                 UIActivity.ActivityType.postToWeibo]
    }
}
