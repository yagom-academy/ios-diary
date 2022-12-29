//
//  DateFormatter+Extension.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/21.
//

import UIKit

final class ErrorAlert {
    static let shared: ErrorAlert = ErrorAlert()
    
    private init() {}
    
    func showErrorAlert(title: String, message: String, actionTitle: String) -> UIAlertController {
        let alert: UIAlertController = UIAlertController(title: title,
                                                         message: message,
                                                         preferredStyle: .alert)
        let alertAction: UIAlertAction = UIAlertAction(title: actionTitle,
                                                       style: .default)
        
        alert.addAction(alertAction)
        return alert
    }
}
