//
//  DiaryTextViewProtocol.swift
//  Diary
//
//  Created by 리지, Goat on 2023/04/27.
//

import UIKit

protocol DiaryTextViewProtocol {
    func configureNavigationBar(viewController: UIViewController)
    func configureDiaryTextView(view: UIView, textView: UITextView)
    func setUpNotification()
}

extension DiaryTextViewProtocol {
    func configureNavigationBar(viewController: UIViewController) {
        let now = Date().timeIntervalSince1970
        let today = Int(now)
        
        viewController.navigationItem.title = DateFormatterManager.convertToFomattedDate(of: today)
    }
    
    func configureDiaryTextView(view: UIView, textView: UITextView) {
        view.addSubview(textView)
        let safeArea = view.safeAreaLayoutGuide
        
        textView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        let heightConstraint = textView.heightAnchor.constraint(equalTo: safeArea.heightAnchor)
        heightConstraint.priority = .defaultHigh
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 14),
            textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -14),
            textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            heightConstraint
        ])
    }
}
