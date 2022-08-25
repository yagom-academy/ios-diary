//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Kiwon Song on 2022/08/25.
//

import UIKit

class DiaryDetailViewController: UIViewController {
    private let diaryDetailView = DiaryDetailView()
    
    override func loadView() {
        self.view = diaryDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.registerForKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeRegisterForKeyboardNotification()
    }
    
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardDownAction),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeRegisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc private func keyBoardShow(notification: NSNotification) {
        guard let userInfo: NSDictionary = notification.userInfo as? NSDictionary,
              let keyboardFrame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else {
            return
        }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        self.diaryDetailView.changeTextViewBottomAutoLayout(keyboardHeight)
    }
    
    @objc private func keyBoardDownAction(_ sender: Notification) {
        self.diaryDetailView.changeTextViewBottomAutoLayout()
    }
    
    func loadData(data: SampleDiaryContent) {
        self.navigationItem.title = data.createdAt.dateFormatted()
        diaryDetailView.configure(with: data)
    }
}
