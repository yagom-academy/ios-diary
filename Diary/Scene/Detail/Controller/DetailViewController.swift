//
//  DetailViewController.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/22.
//

import UIKit

final class DetailViewController: DiaryBaseViewController {
  private let diary: Diary
  lazy var baseView = DetailView(frame: view.bounds)
  
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
    self.addKeyboardObserver(action: #selector(keyboardWillShow))
    addGesture()
    self.addSaveDiaryObserver(action: #selector(diarDataUpdate))
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.updateDiaryData()
  }
  
  deinit {
    self.removeKeyboardObserver()
    self.removeSaveDiaryObserver()
  }
  
  @objc func diarDataUpdate() {
    self.updateDiaryData()
  }
  
  private func updateDiaryData() {
    guard let text = baseView.textView.text else {
      return
    }
    
    CoredataManager.sherd.updataContext(
      title: seperateTitle(from: text),
      content: seperateContent(from: text),
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
    self.showAlert(
      title: "택1",
      message: "무엇을",
      firstActionTitle: "Share...",
      secondActionTitle: "Delete",
      preferredStyle: .actionSheet,
      firstAction: { [weak self] in
        self?.showActivityView(text: "선택하세요")
      }, secondAction: { [weak self] in
        self?.showAlert(
          title: "진짜?",
          message: "정말?",
          firstActionTitle: "취소",
          secondActionTitle: "삭제",
          preferredStyle: .alert,
          secondAction: {
            CoredataManager.sherd.deleteContext(identifier: self?.diary.identifier ?? "")
            self?.navigationController?.pushViewController(MainViewController(), animated: true)
          })
      })
  }
}

// MARK: - keyboard

extension DetailViewController {
  func addGesture() {
    self.view.addGestureRecognizer(setSwipeGesture(action:#selector(keyboardHideDidSwipeDown)))
  }
  
  @objc func keyboardHideDidSwipeDown(gesture: UISwipeGestureRecognizer) {
    view.endEditing(true)
    self.updateDiaryData()
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
