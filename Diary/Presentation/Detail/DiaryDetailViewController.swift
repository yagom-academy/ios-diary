//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by dudu, papri on 2022/06/14.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let diary: Diary?
    
    init(diary: Diary? = nil) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        attribute()
        addSubViews()
        layout()
    }
    
    private func setUp() {
        setUpItem()
        setUpNavigationBar()
        setUpTextView()
    }
    
    private func setUpItem() {
        guard let diary = diary else { return }

        diaryTextView.text = diary.title + "\n\n" + diary.body
    }
    
    private func setUpNavigationBar() {
        if diary == nil {
            title = Date().formattedString
        } else {
            title = diary?.createdDate.formattedString
        }
    }
    
    private func setUpTextView() {        
        diaryTextView.contentOffset = .zero
    }
    
    private func attribute() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubViews() {
        view.addSubview(diaryTextView)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            diaryTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
