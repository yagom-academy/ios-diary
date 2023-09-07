//
//  DiaryViewController.swift
//  Diary
//
//  Created by Redmango, Minsup on 2023/08/30.
//

import UIKit

final class DiaryContentSegregator {
    func segregate(text: String?) -> (title: String, content: String) {
        let paragraphs = text?.components(separatedBy: "\n") ?? []
        
        // 첫 번째 개행 문자 이전의 텍스트를 제목으로 설정합니다.
        if let title = paragraphs.first {
            let content = paragraphs
                             .dropFirst()
                             .joined(separator: "\n")
                             .trimmingCharacters(in: .whitespacesAndNewlines)
            return (title: title, content: content)
        } else {
            return (title: "", content: "")
        }
    }
    
}

final class DiaryContentCompositor {
    func composite(title: String?, content: String?) -> String? {
        let spacer = title == nil ? "" : "\n\n"
        
        return (title ?? "") + spacer + (content ?? "")
    }
}

final class DiaryViewController: UIViewController {
    
    // MARK: - Private Property
    
    private let dataManager: DataManager
    private let diary: Diary?
    private var textView = UITextView()
    private let compositor: DiaryContentCompositor
    private let segregator: DiaryContentSegregator
    
    // MARK: - Lifecycle
    
    init(dataManager: DataManager, diary: Diary? = nil) {
        self.dataManager = dataManager
        
        if diary == nil {
            self.diary = Diary(context: dataManager.container.viewContext)
        } else {
            self.diary = diary
        }
        
        self.compositor = DiaryContentCompositor()
        self.segregator = DiaryContentSegregator()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureTextView()
        registerNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateDiary()
    }
    
    // MARK: - CRUD
    
    private func updateDiary() {
        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedText.isEmpty else { return }
        
        let text = segregator.segregate(text: trimmedText)
        self.diary?.title = text.title
        self.diary?.content = text.content
        self.diary?.createdDate = Date()
        
        dataManager.saveContext()
    }
    
    // MARK: - Private Method(Navigation)
    
    private func configureNavigation() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = .current
        
        let date = dateFormatter.string(from: diary?.createdDate ?? Date())
        
        self.navigationItem.title = date
    }
    
    // MARK: - Private Method(TextView)
    
    private func configureTextView() {
        setupTextView()
        constraintTextView()
    }
    
    private func setupTextView() {
        view.addSubview(textView)
        textView.text = compositor.composite(title: diary?.title, content: diary?.content)
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.becomeFirstResponder()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleEditing))
        self.textView.addGestureRecognizer(tap)
    }
    
    private func constraintTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Private Method(Keyboard)
    
    @objc private func toggleEditing() {
        if textView.isFirstResponder {
            self.textView.resignFirstResponder()
        } else {
            self.textView.becomeFirstResponder()
        }
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keybordWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.size.height
            textView.contentInset.bottom = keyboardHeight
        }
    }
    
    @objc private func keybordWillHide() {
        textView.contentInset = .zero
        updateDiary()
    }
}
