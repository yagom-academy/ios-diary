//
//  DiaryView.swift
//  Diary
//
//  Created by unchain, 웡빙 on 2022/08/17.
//

import UIKit

class DiaryView: UIView {
    let placeHolder = NameSpace.placeHolder
    lazy var diaryTextView: UITextView = {
        let textview = UITextView()
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.text = placeHolder
        textview.font = UIFont.preferredFont(forTextStyle: .title1)
        textview.textColor = .lightGray
        textview.inputAccessoryView = accessoryView
        return textview
    }()
    
    let accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 50))
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NameSpace.close, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .systemGray6
        return button
    }()
    
    init(_ rootViewController: UIViewController) {
        super.init(frame: .zero)
        setupSubviews(rootViewController)
        setupConstraints(rootViewController)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupSubviews(_ rootViewController: UIViewController) {
        rootViewController.view.addSubview(diaryTextView)
        accessoryView.addSubview(closeButton)
    }
    
    private func setupConstraints(_ rootViewController: UIViewController) {
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: rootViewController.view.safeAreaLayoutGuide.topAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: rootViewController.view.safeAreaLayoutGuide.bottomAnchor),
            diaryTextView.leadingAnchor.constraint(equalTo: rootViewController.view.safeAreaLayoutGuide.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: rootViewController.view.safeAreaLayoutGuide.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: accessoryView.leadingAnchor, constant: 350),
            closeButton.trailingAnchor.constraint(equalTo: accessoryView.trailingAnchor),
            closeButton.bottomAnchor.constraint(equalTo: accessoryView.bottomAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
