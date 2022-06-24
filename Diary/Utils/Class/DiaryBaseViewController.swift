//
//  DiaryBaseViewController.swift
//  Diary
//
//  Created by LIMGAUI on 2022/06/24.
//

import UIKit

class DiaryBaseViewController: UIViewController {
  var baseView: DiaryBaseView?
  
  init(baseView: DiaryBaseView?) {
    self.baseView = baseView
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    self.removeKeyboardObserver()
    self.removeSaveDiaryObserver()
  }
  
  private func seperateTitle(from text: String) -> String {
    guard let index = text.firstIndex(of: "\n") else {
      return text
    }
    
    return String(text[..<index])
  }
  
  private func seperateContent(from text: String) -> String {
    guard let index = text.firstIndex(of: "\n") else {
      return ""
    }
    
    return String(text[index...]).trimmingCharacters(in: ["\n"])
  }
  
  func addSaveDiaryObserver(diarysave: Selector, NotifiCationName: String) {
    NotificationCenter.default.addObserver(
      self,
      selector: diarysave,
      name: Notification.Name(NotifiCationName),
      object: nil)
  }
  
  func removeSaveDiaryObserver() {
    NotificationCenter.default.removeObserver(self)
  }
  
  func addKeyboardObserver(_ show: Selector, hide: Selector, swipe: Selector) {
    NotificationCenter.default.addObserver(
      self,
      selector: show,
      name: UIResponder.keyboardWillShowNotification,
      object: nil)
    NotificationCenter.default.addObserver(
      self,
      selector: show,
      name: UIResponder.keyboardWillHideNotification,
      object: nil)
    
    let swipeDown = UISwipeGestureRecognizer(
      target: self,
      action: swipe)
    swipeDown.direction = .down
    self.view.addGestureRecognizer(swipeDown)
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
  
  @objc func keyboardWillShow(_ notification: Notification) {
    guard let userInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey],
          let keyboardFrame = userInfo as? CGRect else { return }
    
    let contentInset = UIEdgeInsets(
      top: .zero,
      left: .zero,
      bottom: keyboardFrame.height,
      right: .zero
    )
    
    self.baseView?.textView.contentInset = contentInset
    self.baseView?.textView.verticalScrollIndicatorInsets = contentInset
  }
  
  @objc func keyboardWillHide(_ notification: Notification) {
    let contentInset = UIEdgeInsets.zero
    self.baseView?.textView.contentInset = contentInset
    self.baseView?.textView.scrollIndicatorInsets = contentInset
  }
}
