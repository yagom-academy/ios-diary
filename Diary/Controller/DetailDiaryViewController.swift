//
//  Diary - DetailDiaryViewController.swift
//  Created by Rhode, 무리.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class DetailDiaryViewController: UIViewController {
    var touchEventYPosition: CGFloat?
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .title3)
        textView.text = "제목을 입력하세요"
        
        return textView
    }()
    
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.text = "내용을 입력하세요"
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSubview()
        configureConstraint()
        checkKeyboard()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        touchEventYPosition = touch.location(in: view).y
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        title = Date().convertDate()
    }
    
    private func configureSubview() {
        view.addSubview(contentStackView)
        contentStackView.addArrangedSubview(titleTextView)
        contentStackView.addArrangedSubview(bodyTextView)
    }
    
    private func configureConstraint() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleTextView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1/15)
        ])
    }
    
    func configureContent(diary: Diary) {
        titleTextView.text = diary.title
        bodyTextView.text = diary.body
    }
    
    private func checkKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//            UIView.animate(withDuration: 1) {
//                self.view.window?.frame.origin.y -= keyboardHeight
//
//            }
//        }
//    }
    
        @objc
        private func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                guard let touchEventYPosition else { return }
                if self.view.frame.origin.y == 0 {
                    self.bodyTextView.frame.origin.y -= touchEventYPosition
                }
            }
        }
    
    @objc
    private func keyboardDidShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            guard let touchEventYPosition else { return }
            if touchEventYPosition > keyboardSize.height {
                self.view.frame.origin.y -= keyboardSize.height-UIApplication.shared.windows.first!.safeAreaInsets.bottom
            }
        }
    }
}
