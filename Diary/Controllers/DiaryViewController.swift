//
//  DiaryItemViewController.swift
//  Diary
//
//  Created by jin on 12/22/27.
//

import UIKit

class DiaryViewController: UIViewController {
    
    var diary: Diary?
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDiaryData()
        configureUI()
        configureNotificationCenter()
        contentTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateDiary()
    }
    
    private func configureDiaryData() {
        if self.diary == nil {
            do {
                try CoreDataManager.shared.createDiary(text: "",
                                                       createdAt: Date().timeIntervalSince1970) { diary in
                    self.diary = diary
                }
            } catch {
                print(error)
            }
        }
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(contentTextView)
        
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constant.spacing),
            contentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constant.spacing),
            contentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                      constant: Constant.spacing),
            contentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func updateContentText(content: String?) {
        self.contentTextView.text = content
    }
    
    func configureNavigationItem() {
        let ellipsisImage = UIImage(systemName: Constant.moreImageName)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: ellipsisImage, style: .plain, target: self, action: #selector(showActionSheet))
    }
    
    @objc func updateDiary() {
        if self.diary != nil {
            guard let diary,
                  let text = contentTextView.text else { return }

            diary.text = text

            do {
                try CoreDataManager.shared.updateDiary(updatedDiary: diary) { diary in
                    self.diary = diary
                }
            } catch {
                print(error)
            }
        }
    }
    
    @objc func showActionSheet() {
        self.contentTextView.resignFirstResponder()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Constant.share, style: .default, handler: showActivityViewController))
        alert.addAction(UIAlertAction(title: Constant.cancel, style: .cancel))
        alert.addAction(UIAlertAction(title: Constant.delete, style: .destructive, handler: showDeleteAlert))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDeleteAlert(_ action: UIAlertAction) {
        let alert = UIAlertController(title: Constant.deleteAlertTitle, message: Constant.deleteAlertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constant.delete, style: .destructive, handler: { _ in
            guard let diary = self.diary else { return }
            
            do {
                try CoreDataManager.shared.deleteDiary(diary: diary) {
                    self.diary = nil
                    self.navigationController?.popViewController(animated: true)
                }
            } catch {
                print(error)
            }
        }))
        
        alert.addAction(UIAlertAction(title: Constant.cancel, style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showActivityViewController(_ action: UIAlertAction) {
        updateDiary()
        let activityViewController = UIActivityViewController(activityItems: [diary?.text ?? ""], applicationActivities: nil)
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: - Keyboard adjusting
extension DiaryViewController {
    
    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDiary), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: NSNotification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            contentTextView.contentInset = .zero
            updateDiary()
        } else {
            contentTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        contentTextView.verticalScrollIndicatorInsets = contentTextView.contentInset

        let selectedRange = contentTextView.selectedRange
        contentTextView.scrollRangeToVisible(selectedRange)
    }
}
