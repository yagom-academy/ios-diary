//
//  DetailDiaryViewController.swift
//  Diary
//
//  Created by yeton, hyeon2 on 2022/08/18.
//

import UIKit

final class DetailDiaryViewController: UIViewController, CoreDataProcessing {
    var content: DiaryContents?
    var isExist: Bool = false
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false

        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItemTitle()
        configureAttributes()
        configureLayout()
        registerForKeyboardShowNotification()
        registerForKeyboardHideNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureTextView()
        textView.becomeFirstResponder()
        textView.keyboardDismissMode = .interactive
        textView.alwaysBounceVertical = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        textView.resignFirstResponder()
    }
    
    func getProcessedContent() -> [String] {
        var content = textView.text.components(separatedBy: "\n\n")
        
        if content.count >= 2 {
            return content
        }
        
        if content[0] == "\n" {
            content[0] = " "
        }
        
        content.append("")
        
        return content
    }
    
    private func configureNavigationItemTitle() {
        let time = content?.createdAt ?? Date().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: time)
        
        navigationItem.title = DateFormatter().format(data: date)
        navigationItem.rightBarButtonItem = .init(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: nil,
            action: #selector(showActionSheet)
        )
    }
    
    @objc private func showActionSheet(sender: AnyObject) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Share", style: .default, handler: { _ in
            self.showActivityView()
        }))
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.showDeleteAlert()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true)
    }
    
    private func showActivityView() {
        guard let content = self.content,
                let title = content.title else {
            return
        }
        
        let activityViewController = UIActivityViewController(
            activityItems: [title],
            applicationActivities: nil
        )
      
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func showDeleteAlert() {
        let action = UIAlertController(title: "진짜요?🥺", message: "정말로 삭제하시겠어요?🦦", preferredStyle: .alert)
        action.addAction(UIAlertAction(title: "취소", style: .cancel))
        action.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            guard let content = self.content else {
                return
            }
            
            self.delete(content)
            self.navigationController?.popViewController(animated: true)
        }))

        self.present(action, animated: true)
    }
    
    private func configureAttributes() {
        view.addSubview(textView)
        view.backgroundColor = .white
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            textView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
            textView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            textView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            )
        ])
    }
    
    private func configureTextView() {
        guard let title = content?.title,
              let body = content?.body else {
            return
        }

        textView.text = title + "\n\n" + body
        textView.contentOffset.y = 0
    }

    private func registerForKeyboardShowNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    @objc private func keyBoardShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo as? NSDictionary else {
            return
        }
        
        guard let keyboardFrame = userInfo.value(
            forKey: UIResponder.keyboardFrameEndUserInfoKey
        ) as? NSValue else {
            return
        }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        textView.contentInset.bottom = keyboardHeight
    }
    
    private func registerForKeyboardHideNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyBoardHide(notification: NSNotification) {
        if !textView.text.isEmpty && isExist == false {
            create(content: getProcessedContent())
        } else if !textView.text.isEmpty && isExist == true {
            update(entity: content ?? DiaryContents(), content: getProcessedContent())
        }
    }
}

extension DetailDiaryViewController: SendDataDelegate {
    func sendData<T>(_ data: T, isExist: Bool) {
        content = data as? DiaryContents
        self.isExist = isExist
    }
}
