//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 리지, goat on 2023/04/27.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    private var diary: SampleDiary?
    private var isAutomaticKeyboard: Bool?
    
    private lazy var diaryTitleField: UITextField = {
        let titleField = UITextField()
        if let diary = self.diary {
            titleField.text = diary.title
        }
        titleField.attributedPlaceholder = NSAttributedString(string: "제목을 입력하세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
        titleField.addDoneButton(title: "Done", target: self, selector: #selector(dismissKeyboard))
        
        return titleField
    }()
    
    private lazy var diaryTextView: UITextView = {
        let textView = UITextView()
        if let diary = self.diary {
            textView.text = diary.body
        } else {
            textView.text = "내용을 입력하세요"
            textView.textColor = .secondaryLabel
        }
     
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.addDoneButton(title: "Done", target: self, selector: #selector(dismissKeyboard))
        
        textView.delegate = self
        
        return textView
    }()
    
    init(diary: SampleDiary?, isAutomaticKeyboard: Bool?) {
        self.diary = diary
        self.isAutomaticKeyboard = isAutomaticKeyboard
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationBar()
        configureDiaryView()
        setUpNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isAutomaticKeyboard == true {
            diaryTextView.addDoneButton(title: "Done", target: self, selector: #selector(dismissKeyboard))
            diaryTitleField.addDoneButton(title: "Done", target: self, selector: #selector(dismissKeyboard))
            diaryTitleField.becomeFirstResponder()
        }
    }
    
    private func configureNavigationBar() {
        let now = Date().timeIntervalSince1970
        let today = now
        
        self.navigationItem.title = DateFormatterManager.shared.convertToFomattedDate(of: today)
    }
    
    private func configureDiaryView() {
        view.addSubview(diaryTitleField)
        view.addSubview(diaryTextView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        diaryTextView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        let textViewHeight = diaryTextView.heightAnchor.constraint(equalTo: safeArea.heightAnchor)
        let textFieldHeight = diaryTitleField.heightAnchor.constraint(equalTo: safeArea.heightAnchor)
        textViewHeight.priority = .defaultHigh
        textFieldHeight.priority = .defaultLow
        
        diaryTextView.translatesAutoresizingMaskIntoConstraints = false
        diaryTitleField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            diaryTitleField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            diaryTitleField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 14),
            diaryTitleField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -14),
            textFieldHeight,
            
            diaryTextView.topAnchor.constraint(equalTo: diaryTitleField.bottomAnchor, constant: 20),
            diaryTextView.leadingAnchor.constraint(equalTo: diaryTitleField.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: diaryTitleField.trailingAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            textViewHeight
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
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        var contentInset = diaryTextView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        diaryTextView.contentInset = contentInset
        diaryTextView.scrollIndicatorInsets = diaryTextView.contentInset
    }

    @objc internal func keyboardWillHide(_ notification: Notification) {
        diaryTextView.contentInset = UIEdgeInsets.zero
        diaryTextView.scrollIndicatorInsets = diaryTextView.contentInset
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension DiaryDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard diaryTextView.textColor == .secondaryLabel else { return }
        diaryTextView.textColor = .label
        diaryTextView.text = nil
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if diaryTextView.text.isEmpty {
            diaryTextView.text = "내용을 입력하세요"
            diaryTextView.textColor = .secondaryLabel
        }
    }
}
