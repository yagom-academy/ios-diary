//
//  DetailDiaryViewController.swift
//  Diary
//
//  Created by yeton, hyeon2 on 2022/08/18.
//

import UIKit

final class DetailDiaryViewController: UIViewController {
    var content: DiarySample?
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false

        return textView
    }()
    
    init(content: DiarySample? = nil) {
        super.init(
            nibName: nil,
            bundle: nil
        )
        
        self.content = content
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItemTitle()
        configureUI()
        setComponents()
        registerForKeyboardNotification()
    }
    
    private func setNavigationItemTitle() {
        let time = content?.createdAt ?? Date().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: time)
        
        navigationItem.title = DateFormatter().format(data: date)
    }
    
    private func configureUI() {
        self.view.addSubview(textView)
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setComponents() {
        guard let content = content else {
            return
        }

        textView.text = content.title + "\n\n" + content.body
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
