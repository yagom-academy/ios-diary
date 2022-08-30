//
//  DiaryEditableViewController.swift
//  Diary
//
//  Created by 민쏜, 보리사랑 on 2022/08/30.
//

import UIKit

class DiaryEditableViewController: UIViewController {
    
    // MARK: - Properties
    
    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.keyboardDismissMode = .interactive
        textView.font = .preferredFont(forTextStyle: .body)
        return textView
    }()
    
    // MARK: - Configuring DiaryItem for Core Data
    
    func splitTitleAndBody(from text: String) -> (title: String, body: String) {
        guard let firstSpaceIndex = text.firstIndex(of: "\n") else {
            
            return (title: text, body: "")
        }
        
        let lastIndex = text.endIndex
        
        let titleSubstring = text[..<firstSpaceIndex]
        let bodySubstring = text[firstSpaceIndex..<lastIndex]
        
        let title = String(titleSubstring)
        var body = String(bodySubstring)
        
        while body.hasPrefix("\n") {
            body.removeFirst()
        }
        
        return (title: title, body: body)
    }
    
    // MARK: Setting Keyboard
    
    @objc func keyboardWillShow(_ sender: Notification) {
        let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        guard let keyboardFrame = keyboardFrame else {
            return
        }
        
        let keyboardHeight: CGFloat = keyboardFrame.height + 50
        contentTextView.contentInset.bottom = keyboardHeight
    }
    
    func setupKeyboardWillShowNoification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    func removeKeyboardWillShowNoification() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    // MARK: Configuring UI
    
    func configureLayout() {
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            contentTextView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 12
            ),
            contentTextView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -12
            ),
            contentTextView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }
    
    func addUIComponents() {
        view.addSubview(contentTextView)
    }
}
