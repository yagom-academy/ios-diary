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
    private let state: DiaryState
    private let manager = PersistenceManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let content = diaryTextView.text
        let date = Date().timeIntervalSince1970
        
        do {
            try manager.createContent(content, date)
        } catch {
            print(error)
        }
    }
    
    init(diaryItem: Diary? = nil, state: DiaryState) {
        self.diaryItem = diaryItem
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureInitailView() {
        guard let diaryItem = diaryItem else {
            self.navigationItem.title = Date.convertToDate(by: Date().timeIntervalSince1970)
            return
        }
        
        self.navigationItem.title = Date.convertToDate(by: diaryItem.date)
        
        guard let content = diaryItem.content else { return }
        
        if content.isEmpty {
            self.diaryTextView.text = nil
            
            return
        }
        
        self.diaryTextView.text = content
    }
    
    @objc private func doneButtonTapped(sender: Any) {
        self.view.endEditing(true)
    }
}

// MARK: UI
extension DiaryDetailViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        diaryTextView.addDoneButton(title: "Done", target: self, selector: #selector(doneButtonTapped))
        configureTextView()
        configureInitailView()
        
        if state == .create {
            diaryTextView.becomeFirstResponder()
        }
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
