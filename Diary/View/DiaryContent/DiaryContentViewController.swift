//
//  DiaryContentViewController.swift
//  Diary
//
//  Created by Hugh, Derrick on 2022/08/17.
//

import UIKit

final class DiaryContentViewController: UIViewController {
    private let diaryDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .caption1)
        return textView
    }()
        
    var diaryViewModel: DiaryContentViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefault()
        registerNotification()
        configureTextView()
    }

    private func setupDefault() {
        self.view.backgroundColor = .white
        let doneButton = UIBarButtonItem(title: "완료",
                                            style: .plain,
                                            target: self,
                                            action: #selector(didTappedDoneButton))
        
        let ellipsisButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                     style: .plain,
                                                     target: self,
                                                     action: #selector(didTappedEllipsisButton))
        
        self.navigationItem.rightBarButtonItems = [doneButton,ellipsisButton]

    }
    
    func configureUI(data: DiaryContent) {
        self.title = data.createdAt.formattedDate
        self.diaryDescriptionTextView.text = data.title + Const.doubleNextLineString + data.body
    }
    
    @objc private func didTappedDoneButton() {
        diaryViewModel?.update(diaryDescriptionTextView.text)
        diaryDescriptionTextView.resignFirstResponder()
    }
    
    @objc private func didTappedEllipsisButton() {
        presentActionSheet()
    }
    
    private func presentActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share...", style: .default) { [weak self]_ in
            self?.presentActivityView()
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self]_ in
            self?.presentDeleteAlert()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(shareAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        alertController.modalPresentationStyle = .overFullScreen
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func presentActivityView() {
        guard let sharingText = diaryDescriptionTextView.text else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [sharingText], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    private func presentDeleteAlert() {
        let alertController = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.diaryViewModel?.remove()
            self?.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func configureTextView() {
        self.view.addSubview(diaryDescriptionTextView)
        
        NSLayoutConstraint.activate([
            diaryDescriptionTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            diaryDescriptionTextView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            diaryDescriptionTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            diaryDescriptionTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        diaryDescriptionTextView.focusTop()
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
    }
    
    @objc private func didEnterBackground() {
        diaryViewModel?.update(diaryDescriptionTextView.text)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height,
            right: 0.0)
        
        diaryDescriptionTextView.contentInset = contentInset
        diaryDescriptionTextView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        diaryDescriptionTextView.contentInset = contentInset
        diaryDescriptionTextView.scrollIndicatorInsets = contentInset
    }
}
