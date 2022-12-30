//
//  EditorViewController.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/21.
//

import CoreData
import UIKit

final class EditorViewController: UIViewController {
    private let editorView: EditorView = EditorView()
    private let content: DiaryData
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let diaryText = editorView.fetchDiaryData()

        if diaryText.isEmpty {
            DiaryDataStore.shared.delete(objectID: content.objectID)
        } else {
            updateDiaryText(with: diaryText)
        }
    }
    
    init(with content: DiaryData) {
        self.content = content
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
        self.navigationItem.title = self.content.createdDateString
        
        guard let title = content.title else {
            return
        }
        let text: String
        
        if let body = content.body {
            text = title + "\(Constant.lineBreak)" + body
        } else {
            text = title
        }
        
        self.editorView.setupTextView(from: text)
    }
    
    private func updateDiaryText(with diaryText: String) {
        let splitedText = diaryText.split(separator: Constant.lineBreak,
                                           maxSplits: 1,
                                           omittingEmptySubsequences: false)
        let title = splitedText[0].description
        let body = splitedText[valid: 1]?.description
        
        DiaryDataStore.shared.updateDiary(
            DiaryData(
                title: title,
                body: body,
                createdAt: content.createdAt,
                objectID: content.objectID
            )
        )
    }
    
    func focusTextView() {
        self.editorView.focusTextView()
    }
}
