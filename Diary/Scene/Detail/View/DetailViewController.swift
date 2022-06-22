//
//  DetailViewController.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/14.
//

import UIKit

final class DetailViewController: UIViewController {
    private enum Constants {
        static let rightBarButtonImage = "ellipsis.circle"
    }
    
    private lazy var detailView = DetailView(frame: view.bounds)
    private let viewModel: DetailViewModel
    
    init(diary: DiaryEntity) {
        self.viewModel = DetailViewModel(diary: diary)
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
        setUpView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.saveDiary(text: detailView.contentTextView.text)
    }
}

extension DetailViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let headerAttributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title2)
        ]
        let bodyAttributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        ]
        
        let textAsNSString = textView.text as NSString
        let replaced = textAsNSString.replacingCharacters(in: range, with: text) as NSString
        let boldRange = replaced.range(of: "\n")
        if boldRange.location <= range.location {
            textView.typingAttributes = bodyAttributes
        } else {
            textView.typingAttributes = headerAttributes
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
        title = viewModel
            .diary
            .createdAt
            .formattedString
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: Constants.rightBarButtonImage),
            style: .plain,
            target: self,
            action: #selector(didTapActionButton)
        )
    }
    
    private func setUpView() {
        detailView.setUpContents(data: viewModel.diary)
        detailView.scrollTextViewToTop()
        detailView.contentTextView.delegate = self
    }
}

// MARK: Objc Method
extension DetailViewController {
    @objc private func didEnterBackground() {
        viewModel.saveDiary(text: detailView.contentTextView.text)
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
        viewModel.saveDiary(text: detailView.contentTextView.text)
    }
}

// MARK: Show ActionSheet
extension DetailViewController {
    private func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: AppConstants.deleteActionTitle, style: .destructive) { _ in
            self.showAlert { [self] _ in
                self.viewModel.deleteDiary()
                navigationController?.popViewController(animated: true)
            }
        }
        
        let shareAction = UIAlertAction(title: AppConstants.shareActionTitle, style: .default) { _ in
            self.showActivityView(data: self.viewModel.diary)
        }
        
        let cancelAction = UIAlertAction(title: AppConstants.cancelActionTitle, style: .cancel)
        
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(shareAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
}
