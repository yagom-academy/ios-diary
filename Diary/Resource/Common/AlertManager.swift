//
//  AlertManager.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/29.
//

import Foundation

class AlertManager {
    static let shared = AlertManager()
    
    func sendError(title: String) {
        let notificationName = Notification.Name("CoreDataError")
        NotificationCenter.default.post(name: notificationName,
                                        object: nil,
                                        userInfo: [Namespace.alertTitle: title])
    }
}
