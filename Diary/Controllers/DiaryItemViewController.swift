//
//  DiaryItemViewController.swift
//  Diary
//
//  Created by jin on 12/22/27.
//

import UIKit

class DiaryItemViewController: UIViewController {
    
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

        if self.isMovingFromParent {
            manageCoreData()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func configureDiaryData() {
        if self.diary == nil {
            self.diary = createCoreData()
        }
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(contentTextView)
        
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            contentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            contentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                      constant: -10),
            contentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func updateContentText(content: String?) {
        self.contentTextView.text = content
    }
    
    func configureNavigationItem() {
        let ellipsisImage = UIImage(systemName: "ellipsis.circle")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: ellipsisImage, style: .plain, target: self, action: #selector(showActionSheet))
    }
    
    @objc func showActionSheet() {
        self.contentTextView.resignFirstResponder()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Share", style: .default))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: showDeleteAlert))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDeleteAlert(_ action: UIAlertAction) {
        let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: deleteCoreData))
        alert.addAction(UIAlertAction(title: "취소", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Keyboard adjusting
extension DiaryItemViewController {
    
    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.manageCoreData), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: NSNotification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            contentTextView.contentInset = .zero
            manageCoreData()
        } else {
            contentTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        contentTextView.verticalScrollIndicatorInsets = contentTextView.contentInset

        let selectedRange = contentTextView.selectedRange
        contentTextView.scrollRangeToVisible(selectedRange)
    }
}

// MARK: - CoreData
extension DiaryItemViewController {
    
    @objc func manageCoreData() {
        if self.diary != nil {
            updateCoreData()
        }
    }
    
    func createCoreData() -> Diary? {
        do {
            return try CoreDataManager.shared.createDiary(text: "", createdAt: Date().timeIntervalSince1970)
        } catch {
            print(error)
        }
        return nil
    }
    
    func updateCoreData() {
        guard let diary,
              let text = contentTextView.text else { return }
        
        diary.text = text
        
        do {
            try CoreDataManager.shared.updateDiary(updatedDiary: diary)
        } catch {
            print(error)
        }
    }
    
    func deleteCoreData(action: UIAlertAction) {
        guard let diary else { return }
        do {
            try CoreDataManager.shared.deleteDiary(diary: diary)
        } catch {
            print(error)
        }
        self.diary = nil
        self.navigationController?.popViewController(animated: true)
    }
}
