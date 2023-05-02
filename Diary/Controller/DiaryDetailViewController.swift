//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by kimseongjun on 2023/04/25.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    enum WriteMode {
        case create
        case update
    }
    
    private var writeMode = WriteMode.create
    private let diary: Diary?
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.layer.borderWidth = 0.8
        textView.layer.cornerRadius = 4
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    init(_ diary: Diary?) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkWriteMode()
        configureUI()
        configureLayout()
        configureNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        saveDiary()
    }
    
    private func checkWriteMode() {
        if diary == nil {
            writeMode = WriteMode.create
        } else {
            writeMode = WriteMode.update
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        switch writeMode {
        case .create:
            self.title = Date.nowDate
            textView.becomeFirstResponder()
        case .update:
            self.title = diary?.timeIntervalSince1970.convertFormattedDate()
            textView.text = formatContent(diary)
        }
    }
    
    private func configureLayout() {
        view.addSubview(textView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8),
            textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8)
        ])
    }
    
    private func formatContent(_ diary: Diary?) -> String? {
        guard let title = diary?.title,
              let body = diary?.body else { return nil}
        
        return title + "\n\n" + body
    }
    
    private func configureNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        
        textView.contentInset.bottom = keyboardFrame.size.height
        textView.scrollIndicatorInsets = textView.contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        textView.contentInset = UIEdgeInsets.zero
        textView.scrollIndicatorInsets = textView.contentInset
        
        saveDiary()
    }
    
    func saveDiary() {
        guard let contents = textView.text,
              verifyText() == true else { return }
        let components = contents.split(separator: "\n", maxSplits: 1)
        guard let title = components[safe: 0], var body = components[safe: 1] else { return }
        
        if body.first == "\n" {
            body.removeFirst()
        }
        
        switch writeMode {
        case .create:
            let currentDiary = Diary(
                id: UUID(),
                title: String(title),
                body: String(body),
                timeIntervalSince1970: Date.nowTimeIntervalSince1970
            )
            
            CoreDataManager.shared.create(currentDiary)
        
        case .update:
            guard let previousDiary = diary else { return }
            
            let currentDiary = Diary(
                id: previousDiary.id,
                title: String(title),
                body: String(body),
                timeIntervalSince1970: previousDiary.timeIntervalSince1970
            )
            
            CoreDataManager.shared.update(currentDiary)
        }
    }
    
    func verifyText() -> Bool {
        
        while true {
            if textView.text.first == " " {
                textView.text.removeFirst()
            } else {
                break
            }
        }
        
        if textView.text.isEmpty {
            return false
        } else {
            return true
        }
    }
    
}
