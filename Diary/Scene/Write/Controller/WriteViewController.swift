//
//  WriteViewController.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/15.
//

import UIKit

final class WriteViewController: DiaryBaseViewController {
  private lazy var baseView = WriteView(frame: view.bounds)
  
  override func loadView() {
    super.loadView()
    view = baseView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    addKeyboardObserver(action: #selector(keyboardWillShow))
    addGesture()
    addSaveDiaryObserver(action: #selector(diaryDataSave))
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    saveDiaryData()
  }
  
  deinit {
    removeKeyboardObserver()
    removeSaveDiaryObserver()
  }
  
  @objc func diaryDataSave() {
    saveDiaryData()
  }
  
  private func configureUI() {
    view.backgroundColor = .systemBackground
    navigationItem.title = Date().setKoreaDateFormat(dateFormat: .yearMonthDay)
  }
  
  private func saveDiaryData() {
    guard let text = baseView.textView.text else {
      return
    }
    
    DiaryData.create (
      title: seperateTitle(from: text),
      content: seperateContent(from: text),
      identifier: UUID().uuidString,
      date: Date())
  }
}


// MARK: - keyboard

private extension WriteViewController {
  func addGesture() {
    view.addGestureRecognizer(setSwipeGesture(action:#selector(keyboardHideDidSwipeDown)))
  }
  
  @objc func keyboardHideDidSwipeDown(gesture: UISwipeGestureRecognizer) {
    view.endEditing(true)
    saveDiaryData()
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
    
    baseView.textView.contentInset = contentInset
    baseView.textView.verticalScrollIndicatorInsets = contentInset
  }
  
  @objc func keyboardWillHide(_ notification: Notification) {
    let contentInset = UIEdgeInsets.zero
    baseView.textView.contentInset = contentInset
    baseView.textView.scrollIndicatorInsets = contentInset
  }
}
