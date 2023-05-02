//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/04/25.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    private var diaryItem: Diary?
    private var state: DiaryState
    private let manager = PersistenceManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(endEditingDiary), name: UIScene.didEnterBackgroundNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if state == .create {
            diaryTextView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        endEditingDiary()
    }
    
    init(diaryItem: Diary? = nil, state: DiaryState) {
        self.diaryItem = diaryItem
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func endEditingDiary() {
        if diaryTextView.text.isEmpty { return }
        
        let content = diaryTextView.text
        let date = Date().timeIntervalSince1970
        
        switch state {
        case .create:
            do {
                diaryItem = try manager.createContent(content, date)
            } catch {
                showFailAlert(error: error)
            }
        case .edit:
            guard let diary = diaryItem else { return }
            
            do {
                try manager.updateContent(at: diary, content, date)
            } catch {
                showFailAlert(error: error)
            }
        }
    }
    
    private func configureInitailView() {
        guard let diaryItem = diaryItem else {
            self.navigationItem.title = Date.convertToDate(by: Date().timeIntervalSince1970)
            
            return
        }
        
        self.navigationItem.title = Date.convertToDate(by: diaryItem.date)
        self.diaryTextView.text = diaryItem.content
    }
    
    @objc private func doneButtonTapped(sender: Any) {
        self.view.endEditing(true)
        
        endEditingDiary()
        state = .edit
    }
}

// MARK: UI
extension DiaryDetailViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        diaryTextView.addDoneButton(title: "Done", target: self, selector: #selector(doneButtonTapped))
        configureTextView()
        configureInitailView()
    }
    
    private func configureTextView() {
        self.view.addSubview(diaryTextView)
        
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            diaryTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor)
        ])
    }
}

fileprivate extension UITextView {
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
