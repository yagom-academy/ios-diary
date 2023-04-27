//
//  DiaryViewController.swift
//  Diary
//
//  Created by 리지, goat on 2023/04/25.
//

import UIKit

final class DiaryViewController: UIViewController {
    
    private var sampleDiary: [SampleDiary]?
    
    private lazy var diaryTextView: UITextView = {
        let textView = UITextView()
        guard let sample = sampleDiary?.first else { return UITextView() }
        textView.text = sample.title + "\n" + sample.body
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = .secondaryLabel
        textView.addDoneButton(title: "Done", target: self, selector: #selector(dismissKeyboard))
        
        return textView
    }()
    
    init(sampleDiary: [SampleDiary]? = nil) {
        self.sampleDiary = sampleDiary
        super.init(nibName: nil, bundle: nil)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        diaryTextView.delegate = self
        
        configureNavigationBar()
        configureDiaryTextView()
        setUpNotification()
    }
    
    private func configureNavigationBar() {
        let now = Date().timeIntervalSince1970
        let today = Int(now)
        
        self.navigationItem.title = DateFormatterManager.convertToFomattedDate(of: today)
    }
    
    private func configureDiaryTextView() {
        view.addSubview(diaryTextView)
        let safeArea = view.safeAreaLayoutGuide
        
        diaryTextView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        let heightConstraint = diaryTextView.heightAnchor.constraint(equalTo: safeArea.heightAnchor)
        heightConstraint.priority = .defaultHigh
        
        diaryTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            diaryTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 14),
            diaryTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -14),
            diaryTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            heightConstraint
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
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
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
    
    func fillSampleDiary(_ dairy: [SampleDiary] ) {
        sampleDiary = dairy
    }
}

extension DiaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .secondaryLabel else { return }
        textView.textColor = .black
    }
}

extension UITextView {
    func addDoneButton(title: String, target: Any, selector: Selector) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                       target: nil,
                                       action: nil)
        let barButton = UIBarButtonItem(title: title,
                                        style: .plain,
                                        target: target,
                                        action: selector)
        
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
}
