//
//  DetailViewController.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/14.
//

import UIKit

final class DetailViewController: UIViewController {
    private enum ExecutionStatus {
        case update
        case delete
    }
    
    private lazy var detailView = DetailView(frame: view.bounds)
    private let diary: DiaryEntity
    private var status: ExecutionStatus = .update
    
    init(diary: DiaryEntity) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        setUpNavigationBar()
        detailView.setUpContents(data: diary)
        detailView.scrollTextViewToTop()
        detailView.contentTextView.delegate = self
        highlightFirstLineInTextView(textView: detailView.contentTextView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        saveDiary()
    }
    
    private func saveDiary() {
        if status == .delete {
            return
        }
        
        guard let content = detailView.contentTextView.text else { return }

        let splitedIndex = content.firstIndex(of: "\n") ?? content.endIndex
        let title = String(content[..<splitedIndex])
        let body = String(content[splitedIndex...])

        let diary = Diary(title: title, createdAt: diary.createdAt, body: body, id: diary.id)
                
        PersistenceManager.shared.execute(by: .update(diary: diary))
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

extension DetailViewController: UITextViewDelegate {
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

extension DetailViewController {
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
        title = diary.createdAt.formattedString
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapActionButton)
        )
    }
}

// MARK: Objc Method

extension DetailViewController {
    @objc private func didEnterBackground() {
        saveDiary()
    }
    
    @objc private func didTapActionButton() {
        showActionSheet()
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

// MARK: Show ActionSheet

extension DetailViewController {
    private func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            PersistenceManager.shared.execute(by: .delete(self.diary))
            self.status = .delete
            self.navigationController?.popViewController(animated: true)
        }
        
        let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            self.showActivityView(data: self.diary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(shareAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
}

// MARK: Show ActivityView

extension DetailViewController {
    private func showActivityView(data: DiaryEntity) {
        let textToShare: [Any] = [
            ShareActivityItemSource(
                title: data.title ?? "제목 없음",
                text: data.createdAt.formattedString)
        ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        present(activityViewController, animated: true)
    }
}
