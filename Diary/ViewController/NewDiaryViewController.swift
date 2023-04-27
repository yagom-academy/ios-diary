//
//  NewDiaryViewController.swift
//  Diary
//
//  Created by 리지, goat on 2023/04/25.
//

import UIKit

final class NewDiaryViewController: UIViewController, DiaryTextViewProtocol, KeyboardProtocol {
    private lazy var diaryTextView: UITextView = {
        let textView = UITextView()
        textView.text = "내용을 입력하세요."
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = .secondaryLabel
        textView.addDoneButton(title: "Done", target: self, selector: #selector(dismissKeyboard))
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        diaryTextView.delegate = self
        
        configureNavigationBar(viewController: self)
        configureDiaryTextView(view: view, textView: diaryTextView)
        setUpNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        diaryTextView.becomeFirstResponder()
    }
    
    func setUpNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        var contentInset = diaryTextView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        diaryTextView.contentInset = contentInset
        diaryTextView.scrollIndicatorInsets = diaryTextView.contentInset
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        diaryTextView.contentInset = UIEdgeInsets.zero
        diaryTextView.scrollIndicatorInsets = diaryTextView.contentInset
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension NewDiaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .secondaryLabel else { return }
        textView.text = nil
        textView.textColor = .black
    }
}
