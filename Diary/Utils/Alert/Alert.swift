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
  let firstAction: (() -> Void)?
  let secondAction: (() -> Void)?
}
