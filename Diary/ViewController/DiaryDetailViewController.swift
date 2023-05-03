//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 리지, goat on 2023/04/27.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    enum Mode {
        case edit
        case create
    }
    
    private let fetchedDiary: DiaryCoreData?
    private var mode: Mode
    private var titleText: String?
    private var bodyText: String?
    
    private lazy var diaryTextView: UITextView = {
        let textView = UITextView()
        
        switch mode {
        case .edit:
            textView.text = fetchedDiary?.body
        case .create:
            textView.text = "내용을 입력하세요"
            textView.textColor = .secondaryLabel
        }
        
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.addDoneButton(title: "Done", target: self, selector: #selector(dismissKeyboard))
        
        textView.delegate = self
        
        return textView
    }()
    
    init(fetchedDiary: DiaryCoreData?, mode: Mode) {
        self.fetchedDiary = fetchedDiary
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationBar()
        configureDiaryView()
        setUpKeyboardNotification()
        setUpBackgroundNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if mode == .create {
            diaryTextView.addDoneButton(title: "Done", target: self, selector: #selector(dismissKeyboard))
            diaryTextView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveDiary()
    }
    
    private func configureNavigationBar() {
        let ellipsisButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(ellipsisButtonTapped))
        navigationItem.rightBarButtonItem = ellipsisButton
        
        switch mode {
        case .edit:
            guard let date = fetchedDiary?.date else { return }
            navigationItem.title = DateFormatterManager.shared.convertToFomattedDate(of: date)
        case .create:
            let today = Date().timeIntervalSince1970
            navigationItem.title = DateFormatterManager.shared.convertToFomattedDate(of: today)
        }
    }
    
    @objc func ellipsisButtonTapped() {
        AlertManager.shared.showActionSheet(target: self,
                                            title: nil,
                                            message: nil,
                                            defaultTitle: "Share...",
                                            destructiveTitle: "Delete",
                                            defaultHandler: { _ in self.showActivityView() },
                                            destructiveHandler: { _ in self.showDeleteAlert() })
    }
    
    private func showActivityView() {
        guard let titleText = titleText,
              let bodyText = bodyText else { return }
        
        let textToShare = DiaryActivityItemSource(title: titleText, body: bodyText)
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func showDeleteAlert() {
        AlertManager.shared.showAlert(target: self,
                                      title: "진짜요?",
                                      message: "정말로 삭제하시겠어요?",
                                      defaultTitle: "취소",
                                      destructiveTitle: "삭제",
                                      destructiveHandler: { _ in
            guard let key = self.fetchedDiary?.title else { return }
            CoreDataManager.shared.delete(key: key)
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    private func configureDiaryView() {
        view.addSubview(diaryTextView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        diaryTextView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        let textViewHeight = diaryTextView.heightAnchor.constraint(equalTo: safeArea.heightAnchor)
        textViewHeight.priority = .defaultHigh
        
        diaryTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            diaryTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            diaryTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -14),
            diaryTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            textViewHeight
        ])
    }
    
    private func setUpKeyboardNotification() {
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
    
    private func setUpBackgroundNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveDiary),
            name: UIScene.willDeactivateNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
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
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func saveDiary() {
        guard let titleText = titleText,
              let bodyText = bodyText else { return }
        
        switch mode {
        case .edit:
            guard let keyTitle = fetchedDiary?.title,
                  let date = fetchedDiary?.date else { return }
            let diary = MyDiary(title: titleText, body: bodyText, createdDate: date)
            CoreDataManager.shared.update(key: keyTitle, diary: diary)
        case .create:
            let today = Double(Date().timeIntervalSince1970)
            let diary = MyDiary(title: titleText, body: bodyText, createdDate: today)
            CoreDataManager.shared.create(diary: diary)
        }
        mode = .edit
    }
}

extension DiaryDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard diaryTextView.textColor == .secondaryLabel else { return }
        diaryTextView.textColor = .label
        diaryTextView.text = nil
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        saveDiary()
        
        if diaryTextView.text.isEmpty {
            diaryTextView.text = "내용을 입력하세요"
            diaryTextView.textColor = .secondaryLabel
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = diaryTextView.text else { return }
        self.titleText = text.components(separatedBy: "\n").first
        self.bodyText = text.replacingOccurrences(of: "\(String(describing: titleText)) \n", with: "")
    }
}
