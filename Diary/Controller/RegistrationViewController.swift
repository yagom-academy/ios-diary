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
        detailView.contentTextView.delegate = self
        highlightFirstLineInTextView(textView: detailView.contentTextView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotification()
        saveDiary()
    }
    
    private func saveDiary() {
        guard let content = detailView.contentTextView.text,
                content.isEmpty == false
        else {
            return
        }
                
        let splitedIndex = content.firstIndex(of: "\n") ?? content.endIndex
        let title = content[..<splitedIndex]
        let body = content[splitedIndex...]

        let diary = Diary(title: String(title), createdAt: createdAt, body: String(body), id: diaryId)
        
        PersistenceManager.shared.execute(by: .create(diary: diary))
    }
    
    private func highlightFirstLineInTextView(textView: UITextView) {
        let textAsNSString = textView.text as NSString
        let lineBreakRange = textAsNSString.range(of: "\n")
        let newAttributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        let boldRange: NSRange
        if lineBreakRange.location < textAsNSString.length {
            boldRange = NSRange(location: 0, length: lineBreakRange.location)
        } else {
            boldRange = NSRange(location: 0, length: textAsNSString.length)
        }
        
        newAttributedText.addAttribute(
            NSAttributedString.Key.font,
            value: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline),
            range: boldRange
        )
        textView.attributedText = newAttributedText
    }
}

extension RegistrationViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let headerAttributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        ]
        let bodyAttributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        ]
        
        let textAsNSString = textView.text as NSString
        let replaced = textAsNSString.replacingCharacters(in: range, with: text) as NSString
        let boldRange = replaced.range(of: "\n")
        if boldRange.location <= range.location {
            textView.typingAttributes = headerAttributes
        } else {
            textView.typingAttributes = bodyAttributes
        }
        
        return true
    }
}

// MARK: SetUp

extension RegistrationViewController {
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
    
    private func removeKeyboardNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func setUpNavigationBar() {
        title = createdAt.formattedString
    }
}

// MARK: Objc Method

extension RegistrationViewController {
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
}

fileprivate extension Date {
    var formattedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ko_KR")
        return dateFormatter.string(from: self)
    }
}
