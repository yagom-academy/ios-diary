//
//  ActivityViewManager.swift
//  Diary
//
//  Created by Erick on 2023/09/10.
//

import UIKit

enum ActivityViewManager {
    static func presentActivityView(to controller: UIViewController, with diary: DiaryEntry) {
        let textData = String(format: "%@\n%@", diary.title, diary.body)
        let activityVC = UIActivityViewController(activityItems: [textData], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = controller.view
        
        controller.present(activityVC, animated: true)
    }
}
