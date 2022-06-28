//
//  Alert.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/28.
//

import UIKit

struct AlertAction {
  let title: String?
  let message: String?
  let firstActionTitle: String?
  let secondActionTitle: String?
  let preferredStyle: UIAlertController.Style
  let firstAction: (() -> Void)?
  let secondAction: (() -> Void)?
  
  init(title: String? = nil, message: String? = nil ,firstActionTitle: String? = nil,secondActionTitle: String? = nil,preferredStyle: UIAlertController.Style = .alert, firstAction: (() -> Void)? = nil, secondAction: (() -> Void)? = nil) {
    self.title = title
    self.message = message
    self.firstActionTitle = firstActionTitle
    self.secondActionTitle = secondActionTitle
    self.preferredStyle = preferredStyle
    self.firstAction = firstAction
    self.secondAction = secondAction
  }
}
