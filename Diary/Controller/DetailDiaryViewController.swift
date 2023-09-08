//
//  DetailDiaryViewController.swift
//  Diary
//
//  Created by Kobe, Moon on 2023/09/02.
//

import UIKit

final class DetailDiaryViewController: UIViewController {
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.keyboardDismissMode = .onDrag
        
        return textView
    }()
    
    private let persistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    private var diary: DiaryEntity
    
    init(diary: DiaryEntity) {
        self.diary = diary
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureDelegates()
        setupKeyboardEvent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveDiaryData()
    }
    
    func fetchDiaryData(_ data: DiaryEntity) {
        guard let title = data.title,
              let body = data.body,
              let createdAt = data.createdAt  else {
            
            return
        }
        
        diary = data
        diaryTextView.text = "\(title)\n\(body)"
        
        configureNavigationItem(date: createdAt)
    }
    
    func saveDiaryData() {
        let splitedText = diaryTextView.text.split(separator: "\n")
        let title = String(splitedText[safe: 0] ?? .init())
        let body = String(diaryTextView.text.dropFirst(title.count))
        
        diary.title = title
        diary.body = body
        
        persistentContainer?.saveContext()
    }
    
    private func configureDelegates() {
        diaryTextView.delegate = self
    }
}

extension DetailDiaryViewController {
    private func configureUI() {
        configureView()
        configureNavigationItem()
        addSubViews()
        diaryTextViewConstraints()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationItem(date: Date = Date()) {
        navigationItem.title = DiaryDateFormatter.convertDate(date, Locale.current.identifier)
    }
    
    private func addSubViews() {
        view.addSubview(diaryTextView)
    }
    
    private func diaryTextViewConstraints() {
        diaryTextView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 15.0, *) {
            NSLayoutConstraint.activate([
                diaryTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                diaryTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                diaryTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                diaryTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                diaryTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                diaryTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                diaryTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                diaryTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    }
}

extension DetailDiaryViewController {
    private func setupKeyboardEvent() {
        if #unavailable(iOS 15.0) {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            
            return
        }
        
        diaryTextView.contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: keyboardFrame.height, right: .zero)
    }
    
    @objc private func keyboardWillHide() {
        diaryTextView.contentInset = UIEdgeInsets()
    }
    
    @objc private func keyboardDidHide() {
        saveDiaryData()
    }
}

extension DetailDiaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.becomeFirstResponder()
    }
}
