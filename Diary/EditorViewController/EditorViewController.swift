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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editorView.scrollToTop()
    }
    
    func configureEditorView(from content: DiaryContent? = nil) {
        if let content = content {
            let text = content.title + "\n\n" + content.body
            editorView.setupTextView(from: text)
        }
        
        self.navigationItem.title = DateLocalizer.localizedString(
            from: content?.createdDate ?? Date(),
            dateStyle: .long,
            timeStyle: .none
        )
    }
}
