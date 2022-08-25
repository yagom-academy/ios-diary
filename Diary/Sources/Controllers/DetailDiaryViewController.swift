//
//  DetailDiaryViewController.swift
//  Diary
//
//  Created by yeton, hyeon2 on 2022/08/18.
//

import UIKit

final class DetailDiaryViewController: UIViewController, CoreDataProcessing {
    private var content: DiaryContents?
    private var isExist: Bool = false
    
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
        registerForKeyboardNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureTextView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !textView.text.isEmpty && isExist == false {
            create(content: getProcessedContent())
        } else if !textView.text.isEmpty && isExist == true {
            update(entity: content ?? DiaryContents(), content: getProcessedContent())
        }
    }
    
    private func getProcessedContent() -> [String] {
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

    private func registerForKeyboardNotification() {
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
}

extension DetailDiaryViewController: SendDataDelegate {
    func sendData<T>(_ data: T, isExist: Bool) {
        content = data as? DiaryContents
        self.isExist = isExist
    }
}
