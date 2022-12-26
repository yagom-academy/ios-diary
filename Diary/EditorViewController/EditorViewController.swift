//
//  EditorViewController.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/21.
//

import UIKit

final class EditorViewController: UIViewController {
    private let editorView: EditorView = EditorView()
    private let content: DiaryContent?
    
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
        self.editorView.scrollToTop()
        self.configureEditorView()
    }
    
    init(with content: DiaryContent?) {
        self.content = content
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureEditorView() {
        self.navigationItem.title = self.content?.createdDateString ?? Date().localizedString()
 
        if let content = content {
            let text = content.title + Constant.doubleBreak + content.body
            self.editorView.setupTextView(from: text)
        }
    }
}

// MARK: - Objc Method
private extension EditorViewController {
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        if let userInfokey = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey],
           let keyboardSize = (userInfokey as? NSValue)?.cgRectValue {
            self.editorView.changeBottomConstant(to: -keyboardSize.height)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        self.editorView.changeBottomConstant(to: 0)
        self.view.layoutIfNeeded()
    }
}
