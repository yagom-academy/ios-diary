//
//  DiaryViewController.swift
//  Diary
//
//  Created by dudu, papri on 2022/06/14.
//

import UIKit

final class DiaryViewController: UIViewController {
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    private let diary: Diary
    
    init(diary: Diary) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        layout()
        setUpItem()
        setUpNavigationBar()
    }
    
    private func addSubViews() {
        view.addSubview(diaryTextView)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            diaryTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            diaryTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            diaryTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setUpItem() {
        diaryTextView.text = diary.title + "\n\n" + diary.body
    }
    
    private func setUpNavigationBar() {
        title = diary.createdDate.formattedString
    }
}
