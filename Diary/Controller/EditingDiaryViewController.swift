//
//  EditingDiaryViewController.swift
//  Diary
//
//  Created by Mary & Whales on 2023/08/30.
//

import UIKit

final class EditingDiaryViewController: UIViewController {
    private var diaryContent: DiaryContent
    
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.keyboardDismissMode = .onDrag
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    init(with diaryContent: DiaryContent) {
        self.diaryContent = diaryContent
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setupConstraints()
        setupDiaryTextView()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        view.addSubview(diaryTextView)
        
        configureNavigationItem()
    }
    
    private func configureNavigationItem() {
        navigationItem.title = diaryContent.date
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            diaryTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func setupDiaryTextView() {
        if diaryContent.title.isEmpty == false {
            diaryTextView.text = String(format: "%@\n\n%@", diaryContent.title, diaryContent.body)
        } else {
            diaryTextView.becomeFirstResponder()
        }
        
        addGesture()
    }
    
    private func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTextView(_:)))
        diaryTextView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func didTapTextView(_ sender: Any) {
        if diaryTextView.isFirstResponder {
            diaryTextView.resignFirstResponder()
        } else {
            diaryTextView.becomeFirstResponder()
        }
    }
}
