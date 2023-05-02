//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by Andrew, brody on 2023/04/25.
//
import UIKit

final class ProcessViewController: UIViewController {
    
    private let diaryTextView = UITextView()
    private let diary: Diary?
    private let diaryService: DiaryService
    
    init(diary: Diary? = nil, diaryService: DiaryService) {
        self.diary = diary
        self.diaryService = diaryService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        configureDiaryTextView()
        setUpNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveDiary()
    }
    
    private func saveDiary() {
        guard let text = diaryTextView.text else {
            return
        }

        let diaryContent = text.components(separatedBy: "\n")
        
        if text.isEmpty {
            processDiary()
        } else if !text.contains("\n") {
            processDiary(title: diaryContent[0])
        } else if !diaryContent[0].isEmpty {
            var body = ""
            for idx in 1..<diaryContent.count {
                body += diaryContent[idx]
            }
            processDiary(title: diaryContent[0], body: body)
        } else {
            var body = ""
            for idx in 1..<diaryContent.count {
                body += diaryContent[idx]
            }
            processDiary(body: body)
        }
    }
    
    func processDiary(title: String = "", body: String = "") {
        guard let diary else {
            diaryService.create(id: UUID(), title: title, body: body)
            return
        }
        
        diaryService.update(id: diary.id, title: title, body: body)
    }
    
    private func configureNavigationItem() {
        let localizedDateFormatter = DateFormatter(
            languageIdentifier: Locale.preferredLanguages.first ?? Locale.current.identifier
        )
        navigationItem.title = localizedDateFormatter.string(from: Date())
    }
    
    private func updateTextView(diary: Diary?) {
        guard let diary else {
            return
        }
        diaryTextView.text = "\(diary.title)\n\(diary.body)"
    }
    
    private func configureDiaryTextView() {
        if diary != nil {
            updateTextView(diary: diary)
        }
        
        view.addSubview(diaryTextView)
        diaryTextView.translatesAutoresizingMaskIntoConstraints = false
        diaryTextView.contentInsetAdjustmentBehavior = .always
        diaryTextView.font = .preferredFont(forTextStyle: .body)
        diaryTextView.adjustsFontForContentSizeCategory = true
        diaryTextView.contentOffset = .zero
        diaryTextView.keyboardDismissMode = .interactive
        
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: view.topAnchor),
            diaryTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setUpNotification() {
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
        var contentInset = diaryTextView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        diaryTextView.contentInset = contentInset
        diaryTextView.scrollIndicatorInsets = diaryTextView.contentInset
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        diaryTextView.contentInset = UIEdgeInsets.zero
        diaryTextView.scrollIndicatorInsets = diaryTextView.contentInset
    }
}
