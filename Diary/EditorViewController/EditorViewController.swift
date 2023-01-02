//
//  EditorViewController.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/21.
//

import CoreData
import UIKit

final class EditorViewController: UIViewController {
    lazy var textViewBottomConstraint = self.textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let content: DiaryData
    
    override func viewDidAppear(_ animated: Bool) {
        if content.title == nil {
            self.textView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let diaryText = textView.text ?? ""
        
        if diaryText.isEmpty {
            DiaryDataStore.shared.delete(objectID: content.objectID)
        } else {
            updateDiaryText(with: diaryText)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureNotification()
        configureView()
        configureTextView()
        configurePanGesture()
        scrollToTop()
    }
    
    init(with content: DiaryData) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                 target: self,
                                                                 action: #selector(tappedDoneButton))
    }
    
    private func configureNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillDisappear),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillAppear),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    private func configureView() {
        self.view.addSubview(textView)
        self.view.backgroundColor = .systemBackground
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            textViewBottomConstraint
        ])
    }
    
    private func configureTextView() {
        self.navigationItem.title = self.content.createdDateString
        
        guard let title = content.title else {
            return
        }
        let text: String
        
        if let body = content.body {
            text = title + "\(Constant.lineBreak)" + body
        } else {
            text = title
        }
        
        self.textView.text = text
    }
    
    private func configurePanGesture() {
        let downPanGesture = UIPanGestureRecognizer()
        downPanGesture.delegate = self
        downPanGesture.addTarget(self, action: #selector(downPanAction))
        self.view.addGestureRecognizer(downPanGesture)
    }
    
    private func scrollToTop() {
        let contentHeight = textView.contentSize.height
        let offSet = textView.contentOffset.x
        let contentOffset = contentHeight - offSet
        textView.contentOffset = CGPoint(x: 0, y: -contentOffset)
    }
    
    private func updateDiaryText(with diaryText: String) {
        let splitedText = diaryText.split(separator: Constant.lineBreak,
                                          maxSplits: 1,
                                          omittingEmptySubsequences: false)
        let title = splitedText[0].description
        let body = splitedText[valid: 1]?.description
        
        DiaryDataStore.shared.updateDiary(
            DiaryData(
                title: title,
                body: body,
                createdAt: content.createdAt,
                objectID: content.objectID
            )
        )
    }
}

// MARK: - objc method
extension EditorViewController {
    @objc func downPanAction(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: textView)
        let location = sender.location(in: textView)
        
        if abs(velocity.y) > abs(velocity.x), velocity.y > 0 {
            if location.y >= textView.bounds.maxY {
                textView.endEditing(true)
            }
        }
    }
    
    @objc func tappedDoneButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        if let userInfokey = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey],
           let keyboardSize = (userInfokey as? NSValue)?.cgRectValue {
            self.textViewBottomConstraint.constant = -keyboardSize.height
            self.textView.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        self.textViewBottomConstraint.constant = 0
        updateDiaryText(with: textView.text)
        self.textView.layoutIfNeeded()
    }
}

extension EditorViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
}
