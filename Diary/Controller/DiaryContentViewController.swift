//
//  DiaryContentViewController.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/26.
//

import UIKit

final class DiaryContentViewController: UIViewController {
    private let diary: DiarySample?
    private let textView = UITextView()
    
    init(diary: DiarySample? = nil) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRootView()
        setUpNavigationBar()
        setUpTextView()
        addObserver()
    }
    
    private func setUpRootView() {
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
    }
    
    private func setUpNavigationBar() {
        let timeInterval = diary?.createdDate ?? Date().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: timeInterval)
        
        navigationItem.title = DateFormatter.diaryForm.string(from: date)
    }
    
    private func setUpTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        
        setUpTextViewLayout()
        configureTextViewContent()
    }
    
    private func configureTextViewContent() {
        guard let content = diary else { return }
        
        textView.text = "\(content.title)\n\n\(content.body)"
    }
    
    private func setUpTextViewLayout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            textView.topAnchor.constraint(equalTo: safe.topAnchor),
            textView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(noti:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc
    private func keyboardWillShow(noti: NSNotification) {
        guard let keyboardSize = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardSize.cgRectValue.height
        
        textView.contentInset.bottom = keyboardHeight
        textView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }
    
    @objc
    private func keyboardWillHide() {
        textView.contentInset.bottom = .zero
        textView.verticalScrollIndicatorInsets.bottom = .zero
    }
}
