//
//  UIViewController+Extension.swift.swift
//  Diary
//
//  Created by song on 2022/06/24.
//

import UIKit

extension UIViewController {
  
  func showAlert(
    title: String?,
    message: String? = nil,
    firstActionTitle: String? = nil,
    secondActionTitle: String? = nil,
    preferredStyle: UIAlertController.Style,
    firstAction: (() -> Void)? = nil,
    secondAction: (() -> Void)? = nil
  ) {
    DispatchQueue.main.async { [weak self] in
      let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
      
      if let action = firstAction {
        let firstAction = UIAlertAction(title: firstActionTitle, style: .default) { _ in
          action()
        }
        alert.addAction(firstAction)
      } else {
        let firstAction = UIAlertAction(title: firstActionTitle, style: .default)
        alert.addAction(firstAction)
      }
      
      if let action = secondAction {
        let secondAction = UIAlertAction(title: secondActionTitle, style: .destructive) { _ in
          action()
        }
        alert.addAction(secondAction)
      } else {
        let secondAction = UIAlertAction(title: secondActionTitle, style: .destructive)
        alert.addAction(secondAction)
      }
      
      self?.present(alert, animated: true)
    }
  }
}
