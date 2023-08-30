//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/08/29.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    private var diaryEntity: DiaryEntity?
    
    private lazy var textView: UITextView = {
        let view: UITextView = UITextView()
        view.text = diaryEntity!.title + "\n\n" + diaryEntity!.body
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureUI()
        configureAutoLayout()
        setUpKeyboardEvent()
    }
    
    init(data: DiaryEntity) {
        self.diaryEntity = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNavigation() {
        navigationItem.title = DateFormatter().formatDate(diaryEntity!)
    }
    
    private func configureUI() {
        view.addSubview(textView)
        view.backgroundColor = .systemBackground
    }
    
    private func configureAutoLayout() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func setUpKeyboardEvent() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        var contentInset = textView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        textView.contentInset = contentInset
        textView.scrollIndicatorInsets = textView.contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        textView.contentInset = UIEdgeInsets.zero
        textView.scrollIndicatorInsets = textView.contentInset
    }
}
