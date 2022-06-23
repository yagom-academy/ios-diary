//
//  UIViewController+.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/22.
//

import UIKit

extension UIViewController {
  func showActivityView() {
    var items = [Any]()
    let shareText = "쿼카꺼"
    items.append(shareText)
    
    let activityVC = UIActivityViewController(
      activityItems: items,
      applicationActivities: nil)
    activityVC.popoverPresentationController?.sourceView = self.view
    self.present(activityVC, animated: true)
  }
}
