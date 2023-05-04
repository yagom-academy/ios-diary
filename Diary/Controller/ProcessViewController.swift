//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by Andrew, brody on 2023/04/25.
//
import UIKit

final class ProcessViewController: UIViewController {
    
    typealias DiaryInformation = (title: String, body: String)
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        diaryTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let diaryInformation = currentDiaryInformation()
        processDiary(diaryInformation)
    }
    
    func currentDiaryInformation() -> DiaryInformation? {
        guard let text = diaryTextView.text else {
            return nil
        }
        
        guard let firstIndex = text.firstIndex(of: "\n") else {
            return (title: text, body: "")
        }
        
        let secondIndex = text.index(after: firstIndex)
        let title = String(text[text.startIndex..<firstIndex])
        let body = String(text[secondIndex...])
        
        return (title: title, body: body)
    }
    
    func processDiary(_ diaryInformation: DiaryInformation?) {
        guard let diaryInformation else {
            return
        }
        
        if let diary {
            diaryService.update(id: diary.id, title: diaryInformation.title, body: diaryInformation.body)
        } else {
            diaryService.create(id: UUID(), title: diaryInformation.title, body: diaryInformation.body)
        }
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
        diaryTextView.font = .preferredFont(forTextStyle: .body)
        diaryTextView.adjustsFontForContentSizeCategory = true
        diaryTextView.contentOffset = .zero
        
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
