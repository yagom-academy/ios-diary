//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by Andrew, brody on 2023/04/25.
//
import UIKit

final class ProcessViewController: UIViewController {
    
    private let diaryTextView = UITextView()
    private let diary: DiaryItem?
    private let layoutType: LayoutType
    
    init(diaryItem: DiaryItem? = nil, type: LayoutType) {
        self.diary = diaryItem
        self.layoutType = type
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
    
    private func configureNavigationItem() {
        let localizedDateFormatter = DateFormatter(
            languageIdentifier: Locale.preferredLanguages.first ?? Locale.current.identifier
        )
        navigationItem.title = localizedDateFormatter.string(from: Date())
    }
    
    private func updateTextView(diaryItem: DiaryItem?) {
        guard let diaryItem else {
            return
        }
        diaryTextView.text = "\(diaryItem.title)\n\n\(diaryItem.body)"
    }
    
    private func configureDiaryTextView() {
        if layoutType == .update {
            updateTextView(diaryItem: diary)
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
