//
//  UIViewController+.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/22.
//

import UIKit

extension UIViewController {
  func showActivityView(text: String) {
    var items = [Any]()
    items.append(text)
    
    let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
    activityVC.popoverPresentationController?.sourceView = self.view
    self.present(activityVC, animated: true)
  }
}

extension UIViewController {
  func showActionSheet(
    alertAction: AlertAction
  ) {
    DispatchQueue.main.async { [weak self] in
      let alert = UIAlertController(title: alertAction.title, message: alertAction.message, preferredStyle: .actionSheet)
      
      if let action = alertAction.firstAction {
        let firstAction = UIAlertAction(title: alertAction.firstActionTitle, style: .default) { _ in
          action()
        }
        alert.addAction(firstAction)
      } else {
        let firstAction = UIAlertAction(title: alertAction.firstActionTitle, style: .default)
        alert.addAction(firstAction)
      }
      
      if let action = alertAction.secondAction {
        let secondAction = UIAlertAction(title: alertAction.secondActionTitle, style: .destructive) { _ in
          action()
        }
        alert.addAction(secondAction)
      } else {
        let secondAction = UIAlertAction(title: alertAction.secondActionTitle, style: .destructive)
        alert.addAction(secondAction)
      }
      
      self?.present(alert, animated: true)
    }
  }
  
  func showAlert(
    alertAction: AlertAction
  ) {
    DispatchQueue.main.async { [weak self] in
      let alert = UIAlertController(title: alertAction.title, message: alertAction.message, preferredStyle: .alert)
      
      if let action = alertAction.firstAction {
        let firstAction = UIAlertAction(title: alertAction.firstActionTitle, style: .default) { _ in
          action()
        }
        alert.addAction(firstAction)
      } else {
        let firstAction = UIAlertAction(title: alertAction.firstActionTitle, style: .default)
        alert.addAction(firstAction)
      }
      
      if let action = alertAction.secondAction {
        let secondAction = UIAlertAction(title: alertAction.secondActionTitle, style: .destructive) { _ in
          action()
        }
        alert.addAction(secondAction)
      } else {
        let secondAction = UIAlertAction(title: alertAction.secondActionTitle, style: .destructive)
        alert.addAction(secondAction)
      }
      
      self?.present(alert, animated: true)
    }
  }
}
