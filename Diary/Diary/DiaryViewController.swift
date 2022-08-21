//
//  DiaryViewController.swift
//  Diary
//
//  Created by unchain, 웡빙 on 2022/08/17.
//

import UIKit

final class DiaryViewController: UIViewController {
    // MARK: - Properties

    private let diaryView = DiaryView(frame: .zero)

    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        setupNavigationTitle()
        setupKeyboard()
    }
    
    // MARK: - Methods

    private func setupInitialView() {
        view.backgroundColor = .systemBackground
        view.addSubview(diaryView)
        setDiaryViewConstraint()
    }
    
    private func setupNavigationTitle() {
        let now = Date()
        navigationItem.title = now.timeIntervalSince1970.translateToDate()
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillAppear),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillDisAppear),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        diaryView.closeButton.addTarget(self,
                                        action: #selector(hideKeyboard),
                                        for: .touchUpInside)
    }
    
    private func setDiaryViewConstraint() {
        diaryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            diaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            diaryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    @objc func keyboardWillAppear(_ sender: Notification) {
        guard let userInfo = sender.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.size.height, right: 0.0)
        diaryView.diaryTextView.contentInset = contentInset
        diaryView.diaryTextView.scrollIndicatorInsets = contentInset
    }
    
    @objc func keyboardWillDisAppear(_ sender: Notification) {
        let contentInset = UIEdgeInsets.zero
        diaryView.diaryTextView.contentInset = contentInset
        diaryView.diaryTextView.scrollIndicatorInsets = contentInset
    }
    
    @objc func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
}
