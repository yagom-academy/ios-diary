//
//  AlertManager.swift
//  Diary
//
//  Created by 리지, goat on 2023/05/02.
//

import UIKit

final class AlertManager {
    static let shared = AlertManager()
    private init() { }
    
    func showAlert(target: UIViewController, title: String, message: String?, defaultTitle: String, destructiveTitle: String?, destructiveHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: defaultTitle, style: .default)
        
        alert.addAction(defaultAction)
        
        if destructiveTitle != nil {
            let destructiveAction = UIAlertAction(title: destructiveTitle, style: .destructive, handler: destructiveHandler)
            alert.addAction(destructiveAction)
        }
        
        target.present(alert, animated: true)
    }
    
    func showActionSheet(target: UIViewController, title: String?, message: String?, defaultTitle: String, destructiveTitle: String, defaultHandler: ((UIAlertAction) -> Void)?, destructiveHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(title: defaultTitle, style: .default, handler: defaultHandler)
        let destructiveAction = UIAlertAction(title: destructiveTitle, style: .destructive, handler: destructiveHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(defaultAction)
        alert.addAction(destructiveAction)
        alert.addAction(cancelAction)
        
        target.present(alert, animated: true)
    }
    
    func showErrorAlert(target: UIViewController, error: DiaryError) {
        let alert = UIAlertController(title: "\(error.description)가 발생하였습니다.", message: "다시 시도해주세요.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(defaultAction)
        target.present(alert, animated: true)
    }
}

