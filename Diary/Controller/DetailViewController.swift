//
//  DetailViewController.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/14.
//

import UIKit

final class DetailViewController: UIViewController {
    private lazy var detailView = DetailView(frame: view.bounds)
    private let diary: DiaryEntity
    
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
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        saveDiary()
    }
    
    private func saveDiary() {
        let content = detailView.contentTextView.text
        var splitedContent = content?.components(separatedBy: "\n\n")
        guard let title = splitedContent?.removeFirst(),
              let body = splitedContent?.joined()
        else {
            return
        }

        let diary = Diary(title: title, createdAt: diary.createdAt, body: body, id: diary.id)
                
        PersistenceManager.shared.execute(by: .update(diary: diary))
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
