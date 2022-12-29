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
    private let content: Diary
        
    override func loadView() {
        super.loadView()
        self.view = editorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureNotification()
        configureEditorView()
        self.editorView.scrollToTop()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if content.title == nil {
            self.editorView.focusTextView()
        }
    }
    
    init(with content: Diary, _ container: NSPersistentContainer) {
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
        let diaryData = editorView.fetchDiaryData()
        let diary = Diary(context: context)
        let splitedDiary = diaryData.split(separator: Constant.lineBreak, maxSplits: 1, omittingEmptySubsequences: true)
        
        diary.title = splitedDiary[0].description
        diary.body = splitedDiary[1].description
        diary.createdAt = content.createdAt
        
//        context.insertDiary(diary)
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
        self.navigationItem.title = self.content.createdDateString
        
        guard let title = content.title,
              let body = content.body else {
            return
        }
        
        let text = title + "\(Constant.lineBreak)" + body
        self.editorView.setupTextView(from: text)
    }
    
    func focusTextView() {
        self.editorView.focusTextView()
    }
}
