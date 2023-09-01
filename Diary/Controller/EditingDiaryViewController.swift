//
//  EditingDiaryViewController.swift
//  Diary
//
//  Created by Mary & Whales on 2023/08/30.
//

import UIKit

final class EditingDiaryViewController: UIViewController {
    private var diaryContent: DiaryContent
    private let hasContents: Bool
    
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.keyboardDismissMode = .onDrag
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    init(with diaryContent: DiaryContent) {
        self.diaryContent = diaryContent
        hasContents = diaryContent.title.isEmpty ? false : true
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setUpConstraints()
        fillDiaryTextView()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        view.addSubview(diaryTextView)
        
        configureNavigationItem()
    }
    
    private func configureNavigationItem() {
        navigationItem.title = diaryContent.date
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            diaryTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func fillDiaryTextView() {
        if hasContents {
            diaryTextView.text = String(format: "%@\n\n%@", diaryContent.title, diaryContent.body)
        }
    }
}
