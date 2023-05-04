//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by kimseongjun on 2023/04/25.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    private enum LocalizationKey {
        static let barButtonTitle = "barButtonTitle"
        static let delete = "delete"
        static let cancel = "cancel"
        static let share = "share"
        static let more = "more"
    }
    
    enum WriteMode {
        case create
        case update
    }
    
    private var writeMode = WriteMode.create
    private let diary: Diary?
    private var id = UUID()
    private var isSave: Bool = true
    
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
        configureNavigationBar()
        configureNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if isSave {
            saveDiaryToStorage()
        }
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
            guard let validDiary = diary else { return }
            
            self.title = validDiary.timeIntervalSince1970.convertFormattedDate()
            self.id = validDiary.id
            textView.text = formatContent(validDiary)
        }
    }
    
    private func formatContent(_ diary: Diary?) -> String? {
        guard let title = diary?.title,
              let body = diary?.body else { return nil}
        
        return title + "\n\n" + body
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
    
    private func configureNavigationBar() {
        let buttonItem: UIBarButtonItem = {
            let button = UIBarButtonItem(
                title: String.localized(key: LocalizationKey.more),
                style: .plain,
                target: self,
                action: #selector(presentActionSheet)
            )
            
            return button
        }()
        
        self.navigationItem.rightBarButtonItem = buttonItem
    }
    
    @objc private func presentActionSheet() {
        let shareActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
      
        let cancelAction = UIAlertAction(title: String.localized(key: LocalizationKey.cancel), style: .cancel)
        let shareAction = UIAlertAction(title: String.localized(key: LocalizationKey.share), style: .default) { _ in
            self.showActivityViewController()
        }
        
        let deleteAction = UIAlertAction(title: String.localized(key: LocalizationKey.delete), style: .destructive) { [weak self] _ in
            guard let id = self?.id else { return }
            
            CoreDataManager.shared.delete(id: id)
            self?.isSave = false
            self?.navigationController?.popViewController(animated: true)
        }
          
        shareActionSheet.addAction(cancelAction)
        shareActionSheet.addAction(shareAction)
        shareActionSheet.addAction(deleteAction)
        
        present(shareActionSheet, animated: true)
    }
    
    private func showActivityViewController() {
        let shareObject = [Any]()
        
        let activityViewController = UIActivityViewController(activityItems: shareObject, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
   
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
        
        saveDiaryToStorage()
    }
    
    @objc private func didEnterBackground() {
        saveDiaryToStorage()
    }
    
    private func saveDiaryToStorage() {
        guard let contents = verifyText(text: textView.text) else { return }
        let components = contents.split(separator: "\n", maxSplits: 1)
        
        guard let title = components[safe: 0] else { return }
        var body = components[safe: 1] ?? ""
        
        if body.first == "\n" {
            body.removeFirst()
        }
        
        let currentDiary = Diary(
            id: self.id,
            title: String(title),
            body: String(body),
            timeIntervalSince1970: self.title?.convertToTimeInterval() ?? Date.nowTimeIntervalSince1970
        )
        CoreDataManager.shared.register(currentDiary)
    }
    
    private func verifyText(text: String) -> String? {
        var rawText = text
        
        while true {
            if rawText.first == " " {
                rawText.removeFirst()
            } else {
                break
            }
        }
        
        if rawText.isEmpty {
            return nil
        } else {
            return rawText
        }
    }
}
