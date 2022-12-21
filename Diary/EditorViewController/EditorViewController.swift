//
//  EditorViewController.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/21.
//

import UIKit

final class EditorViewController: UIViewController {
    private let editorView: EditorView = EditorView()
    
    override func loadView() {
        super.loadView()
        self.view = editorView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillDisappear),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillAppear),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editorView.scrollToTop()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func configureEditorView(from content: DiaryContent? = nil) {
        if let content = content {
            let text = content.title + Constant.doubleBreak + content.body
            editorView.setupTextView(from: text)
        }
        
        self.navigationItem.title = DateLocalizer.localizedString(
            from: content?.createdDate ?? Date(),
            dateStyle: .long,
            timeStyle: .none
        )
    }
}

// MARK: - Objc Method
private extension EditorViewController {
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        if let userInfokey = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey],
           let keyboardSize = (userInfokey as? NSValue)?.cgRectValue {
            editorView.changeBottomConstant(to: -keyboardSize.height)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        editorView.changeBottomConstant(to: 0)
        self.view.layoutIfNeeded()
    }
}
