//
//  RegistrationViewController.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/17.
//

import UIKit

final class RegistrationViewController: UIViewController {
    private lazy var detailView = DetailView(frame: view.bounds)
    private var diary: DiaryEntity?
    private let createdAt = Date().timeIntervalSince1970
    private let diaryId = UUID().uuidString
    
    override func loadView() {
        super.loadView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        setUpNavigationBar()
        detailView.scrollTextViewToTop()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        saveDiary()
    }
    
    private func registerNotification() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(didEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    private func setUpNavigationBar() {
        title = createdAt.formattedString
    }
    
    @objc private func didEnterBackground() {
        saveDiary()
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
        if let keyboardSize = (keyboardInfo as? NSValue)?.cgRectValue {
            detailView.adjustConstraint(by: keyboardSize.height)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        detailView.adjustConstraint(by: .zero)
        saveDiary()
    }
    
    private func saveDiary() {
        guard let content = detailView.contentTextView.text,
                content.isEmpty == false
        else {
            return
        }
        
        var splitedContent = content.components(separatedBy: "\n\n")
        
        let title = splitedContent.removeFirst()
        let body = splitedContent.joined()

        let diary = Diary(title: title, createdAt: createdAt, body: body, id: diaryId)
        
        PersistenceManager.shared.execute(by: .create(diary: diary))
    }
}

fileprivate extension Date {
    var formattedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ko_KR")
        return dateFormatter.string(from: self)
    }
}
