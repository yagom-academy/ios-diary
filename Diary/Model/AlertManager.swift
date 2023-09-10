//
//  AlertManager.swift
//  Diary
//
//  Created by Erick on 2023/09/09.
//

import UIKit

enum AlertManager {
    static func presentFailAlert(to controller: UIViewController, with message: String) {
        let alertAction = UIAlertAction(title: "확인", style: .cancel)
        let alert = UIAlertController.customAlert(alertTile: "실패", alertMessage: message, preferredStyle: .alert, alertActions: [alertAction])
        
        controller.present(alert, animated: true)
    }
    
    static func presentDeleteAlert(to controller: UIViewController, with action: ((UIAlertAction) -> Void)?) {
        let alertAction = UIAlertAction(title: "삭제", style: .destructive, handler: action)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let alert = UIAlertController.customAlert(alertTile: "진짜요?", alertMessage: "정말로 삭제하시겠어요?", preferredStyle: .alert, alertActions: [alertAction, cancelAction])
        
        controller.present(alert, animated: true)
    }
}
