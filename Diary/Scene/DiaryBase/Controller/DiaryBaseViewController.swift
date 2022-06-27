//
//  DiaryBaseViewController.swift
//  Diary
//
//  Created by LIMGAUI on 2022/06/24.
//

import UIKit

class DiaryBaseViewController: UIViewController {
  deinit {
    removeKeyboardObserver()
    removeSaveDiaryObserver()
  }
  
  func seperateTitle(from text: String) -> String {
    guard let index = text.firstIndex(of: "\n") else {
      return text
    }
    
    return String(text[..<index])
  }
  
  func seperateContent(from text: String) -> String {
    guard let index = text.firstIndex(of: "\n") else {
      return ""
    }
    
    return String(text[index...]).trimmingCharacters(in: ["\n"])
  }
}

// MARK: saveDiaryData Notification

extension DiaryBaseViewController {
  func addSaveDiaryObserver(action: Selector) {
    NotificationCenter.default.addObserver(
      self,
      selector: action,
      name: UIApplication.didEnterBackgroundNotification,
      object: nil)
  }
  
  func removeSaveDiaryObserver() {
    NotificationCenter.default.removeObserver(self)
  }
}

// MARK: - keyboard

extension DiaryBaseViewController {
  func addKeyboardObserver(action: Selector) {
    NotificationCenter.default.addObserver(
      self,
      selector: action,
      name: UIResponder.keyboardWillShowNotification,
      object: nil)
    NotificationCenter.default.addObserver(
      self,
      selector: action,
      name: UIResponder.keyboardWillHideNotification,
      object: nil)
  }
  
  func setSwipeGesture(action: Selector) -> UISwipeGestureRecognizer {
    let swipeDown = UISwipeGestureRecognizer(
      target: self,
      action: action
    )
    swipeDown.direction = .down
    return swipeDown
  }
  
  func removeKeyboardObserver() {
    NotificationCenter.default.removeObserver(
      self,
      name: UIResponder.keyboardWillShowNotification,
      object: nil)
    NotificationCenter.default.removeObserver(
      self,
      name: UIResponder.keyboardWillHideNotification,
      object: nil)
  }
}
 
