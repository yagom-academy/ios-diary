//
//  ActivityViewManager.swift
//  Diary
//
//  Created by Erick on 2023/09/10.
//

import UIKit

enum ActivityViewManager {
    
    static func presentActivityView(to controller: UIViewController, with diary: DiaryEntry) {
        let diaryText = String(format: "%@\n%@", diary.title, diary.body)
        let activity = UIActivityViewController(activityItems: [diaryText], applicationActivities: nil)
        activity.popoverPresentationController?.sourceView = controller.view
        
        controller.present(activity, animated: true)
    }
}
