//
//  DetailViewController.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/14.
//

import UIKit

final class DetailViewController: UIViewController {
    private var detailView = DetailView()
    private var diaryData: DiaryInfo?
    
    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if #unavailable(iOS 15.0) {
            registerForKeyboardNotification()
            setViewGesture()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeRegisterForKeyboardNotification()
    }
    
    func updateData(diary: DiaryInfo) {
        diaryData = diary
        detailView.setData(with: diary)
//        navigationItem.title = diary.date.toString
    }
}

// MARK: - Keyboard Method

extension DetailViewController {
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
     }
    
    private func removeRegisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func setViewGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDownAction))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func keyBoardShow(notification: NSNotification) {
        guard let userInfo: NSDictionary = notification.userInfo as? NSDictionary else {
            return
        }
        guard let keyboardFrame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else {
            return
        }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyBoardSize = keyboardRectangle.height
        detailView.changeTextViewHeight(keyBoardSize)
    }
    
    @objc func keyboardDownAction(_ sender: UISwipeGestureRecognizer) {
        self.view.endEditing(true)
        detailView.changeTextViewHeight()
    }
}
