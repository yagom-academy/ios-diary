//
//  EditorViewController.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/21.
//

import CoreData
import UIKit

final class EditorViewController: UIViewController {
    private let container: NSPersistentContainer
    private let editorView: EditorView = EditorView()
    private let content: DiaryContent?
    
    override func loadView() {
        super.loadView()
        self.view = editorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editorView.scrollToTop()
        configureNotification()
        configureEditorView()
    }
    
    init(with content: DiaryContent?, _ container: NSPersistentContainer) {
        self.content = content
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        guard let content = content else { return }
        let text = content.title + Constant.doubleBreak + content.body
        self.editorView.setupTextView(from: text)
    }
}
