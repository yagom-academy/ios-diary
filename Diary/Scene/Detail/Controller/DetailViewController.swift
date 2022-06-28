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
    view = baseView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    addKeyboardObserver(action: #selector(keyboardWillShow))
    addGesture()
    addSaveDiaryObserver(action: #selector(diarDataUpdate))
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    updateDiaryData()
  }
  
  deinit {
    removeKeyboardObserver()
    removeSaveDiaryObserver()
  }
  
  @objc func diarDataUpdate() {
    updateDiaryData()
  }
  
  private func updateDiaryData() {
    guard let text = baseView.textView.text else {
      return
    }
    
    CoreData.updateDiary(
      title: seperateTitle(from: text),
      date: diary.createdDate.bindOptional(),
      content: seperateContent(from: text),
      identifier: diary.identifier.bindOptional())
  }
  
  private func configureUI() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "ellipsis"),
      style: .plain,
      target: self,
      action: #selector(actionSheetWillShow)
    )
    navigationItem.title = diary.createdDate?.setKoreaDateFormat(dateFormat: .yearMonthDay)
    baseView.updateTextView(diary: diary)
  }

  @objc func actionSheetWillShow() {
    let alertConst = AlertAction(
      title: "진짜?",
      message: "정말",
      firstActionTitle: "취소",
      secondActionTitle: "삭제",
      firstAction: nil) { [weak self] in
      CoreData.deleteDiary(identifier: self?.diary.identifier ?? "")
        self?.navigationController?.pushViewController(MainViewController(), animated: true)
    }
    
    let actionSheetConst = AlertAction(
      title: "택1",
      message: "무엇을",
      firstActionTitle: "Share...",
      secondActionTitle: "Delete",
      firstAction:  { [weak self] in
        self?.showActivityView(text: "선택하세요")},
      secondAction: { [weak self] in
      self?.showAlert(alertAction: alertConst)
    })
    
    showActionSheet(alertAction: actionSheetConst)
  }
}

// MARK: - keyboard

private extension DetailViewController {
  func addGesture() {
    view.addGestureRecognizer(setSwipeGesture(action:#selector(keyboardHideDidSwipeDown)))
  }
  
  @objc func keyboardHideDidSwipeDown(gesture: UISwipeGestureRecognizer) {
    view.endEditing(true)
    updateDiaryData()
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

