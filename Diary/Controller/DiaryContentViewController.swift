//
//  DiaryContentViewController.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/26.
//

import UIKit

final class DiaryContentViewController: UIViewController {
    typealias DiaryText = (title: String?, body: String?)
    
    private var diaryContents: DiaryContents?
    private let textView = UITextView()

    init(diaryContents: DiaryContents? = nil) {
        self.diaryContents = diaryContents
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDiaryIfNeeded()
        setUpRootView()
        setUpNavigationBar()
        setUpTextView()
        addObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showKeyboardIfNeeded()
    }
    
    private func setUpRootView() {
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
    }
    
    private func setUpNavigationBar() {
        let timeInterval = diaryContents?.createdDate ?? Date().timeIntervalSince1970
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
        guard let content = diaryContents else { return }
        
        if let title = content.title, let body = content.body {
            textView.text = title + body
        } else {
            textView.text = content.title
        }
        
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
        
        updateDiary()
    }
    
    private func updateDiary() {
        let devidedContents: DiaryText = devide(text: textView.text)
        let updatedDate = Date().timeIntervalSince1970
        
        diaryContents?.updateContents(title: devidedContents.title,
                              body: devidedContents.body,
                              createdDate: updatedDate)
        
        DiaryCoreDataManager.shared.updateDiary(with: diaryContents)
    }
    
    private func devide(text: String?) -> DiaryText {
        guard let text,
              let newLineIndex = text.firstIndex(of: "\n") else { return (text, nil) }
        
        let startIndex = text.startIndex
        let titleRange = startIndex..<newLineIndex
        let bodyRange = newLineIndex...
        let title = String(text[titleRange])
        let body = String(text[bodyRange])
        
        return (title, body)
    }
    
    private func showKeyboardIfNeeded() {
        if diaryContents?.title == "" {
            textView.becomeFirstResponder()
        }
    }
    
    private func createDiaryIfNeeded() {
        if diaryContents == nil {
            let createdDate = Date().timeIntervalSince1970
            let diaryContents = DiaryContents(title: "", body: "", createdDate: createdDate, id: UUID())
            
            self.diaryContents = diaryContents
            DiaryCoreDataManager.shared.createDiary(with: diaryContents)
        }
    }
}
