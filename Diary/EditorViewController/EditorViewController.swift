//
//  EditorViewController.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/21.
//

import CoreData
import UIKit

final class EditorViewController: UIViewController, PersistentContainer {
    let container: NSPersistentContainer
    private let editorView: EditorView = EditorView()
    private let content: Diary?
    
    override func loadView() {
        super.loadView()
        self.view = editorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.editorView.scrollToTop()
        configureNavigationBar()
        configureNotification()
        configureEditorView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if content == nil {
            self.editorView.focusTextView()
        }
    }
    
    init(with content: Diary?, _ container: NSPersistentContainer) {
        self.content = content
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                 target: self,
                                                                 action: #selector(tappedDoneButton))
    }
    
    @objc func tappedDoneButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func configureNotification() {
        NotificationCenter.default.addObserver(
            self.editorView,
            selector: #selector(self.editorView.keyboardWillDisappear),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self.editorView,
            selector: #selector(self.editorView.keyboardWillAppear),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    private func configureEditorView() {
        self.navigationItem.title = self.content?.createdDateString ?? Date().localizedString()
        
        guard let content = content,
              let title = content.title,
              let body = content.body else {
            return
        }
        
        let text = title + Constant.doubleBreak + body
        self.editorView.setupTextView(from: text)
    }
    
    func focusTextView() {
        self.editorView.focusTextView()
    }
}
