//
//  WriteViewController.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/15.
//

import UIKit

final class WriteViewController: UIViewController {
  lazy var baseView = WriteView(frame: view.bounds)
  private var keyboardSize: CGRect?
  
  override func loadView() {
    super.loadView()
    self.view = baseView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.addKeyboardObserver()
    self.addSaveDiaryObserver()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.saveDiaryData()
  }
  
  deinit {
    self.removeKeyboardObserver()
    self.removeSaveDiaryObserver()
  }
  
  private func configureUI() {
    self.view.backgroundColor = .systemBackground
    self.navigationItem.title = Date().setKoreaDateFormat(dateFormat: .yearMonthDay)
  }
  
  private func saveDiaryData() {
    guard let text = baseView.textView.text else {
      return
    }
    
    CoredataManager.sherd.createContext(
      title: seperateTitle(from: text),
      content: seperateContent(from: text),
      identifier: UUID().uuidString,
      date: Date())
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
}

// MARK: saveDiaryData Notification

private extension WriteViewController {
  // SceneDidEnterBackground
  func addSaveDiaryObserver() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(diarDataSave),
      name: Notification.Name("saveDiaryData"),
      object: nil)
  }
  
  func removeSaveDiaryObserver() {
    NotificationCenter.default.removeObserver(self)
  }

  @objc func diarDataSave() {
    self.saveDiaryData()
  }
}

// MARK: Keyboard Notification

private extension WriteViewController {
  func addKeyboardObserver() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil)
    
    let swipeDown = UISwipeGestureRecognizer(
      target: self,
      action: #selector(keyboardHideDidSwipeDown)
    )
    swipeDown.direction = .down
    self.view.addGestureRecognizer(swipeDown)
  }
  
  @objc func keyboardHideDidSwipeDown(gesture: UISwipeGestureRecognizer) {
    view.endEditing(true)
    self.saveDiaryData()
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
    
    self.baseView.textView.contentInset = contentInset
    self.baseView.textView.verticalScrollIndicatorInsets = contentInset
  }
  
  @objc func keyboardWillHide(_ notification: Notification) {
    let contentInset = UIEdgeInsets.zero
    self.baseView.textView.contentInset = contentInset
    self.baseView.textView.scrollIndicatorInsets = contentInset
  }
}
