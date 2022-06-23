//
//  DetailViewController.swift
//  Diary
//
//  Created by LIMGAUI on 2022/06/22.
//

import UIKit

final class DetailViewController: UIViewController {
  lazy var baseView = DetailView(frame: view.bounds)
  private var keyboardSize: CGRect?
  private let diary: Diary
  
  init(diary: Diary) {
    self.diary = diary
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    super.loadView()
    self.view = baseView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.addKeyboardObserver()
    self.addUpdateDiaryObserver()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.updateDiaryData()
  }
  
  private func updateDiaryData() {
    guard let title = diary.title,
    let content = diary.content else {
      return
    }
    CoredataManager.sherd.updataContext(
      title: title,
      content: content,
      identifier: diary.identifier.bindOptional(),
      date: diary.createdDate.bindOptional())
  }
  
  private func configureUI() {
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "ellipsis"),
      style: .plain,
      target: self,
      action: #selector(actionSheetWillShow)
    )
    self.navigationItem.title = diary.createdDate?.setKoreaDateFormat(dateFormat: .yearMonthDay)
    self.baseView.updateTextView(diary: diary)
  }
  
  @objc func actionSheetWillShow() {
    self.showViewMoreAlert()
  }
  
  deinit {
    self.removeKeyboardObserver()
    self.removeSaveDiaryObserver()
  }
  
  private func showViewMoreAlert(){
    let alertVC = UIAlertController(
      title: "택1하셈",
      message: "무엇을 택1 할것인가",
      preferredStyle: .actionSheet)

    let shareAction = UIAlertAction(title: "Share...", style: .default) { _ in
      self.showActivityView()
    }

    let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
      self.showDeleteAlert()
    }

    alertVC.addAction(shareAction)
    alertVC.addAction(deleteAction)
    
    present(alertVC, animated: true)

  }

  private func showDeleteAlert() {
    let alertVC = UIAlertController(
      title: "진짜요?",
      message: "정말로 삭제하시겠어요?",
      preferredStyle: .alert)

    let cancelAction = UIAlertAction(title: "취소", style: .default)

    let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
      CoredataManager.sherd.deleteContext(identifier: self.diary.identifier.bindOptional())
      self.navigationController?.popViewController(animated: true)
    }

    alertVC.addAction(cancelAction)
    alertVC.addAction(deleteAction)
    self.present(alertVC, animated: true)
  }
}

// MARK: saveDiaryData Notification

private extension DetailViewController {
  // SceneDidEnterBackground
  func addUpdateDiaryObserver() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(diarDataUpdate),
      name: Notification.Name("saveDiaryData"),
      object: nil)
  }
  
  func removeSaveDiaryObserver() {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func diarDataUpdate() {
    self.updateDiaryData()
  }
}

// MARK: Keyboard Notification

private extension DetailViewController {
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
