//
//  DetailDiaryViewController.swift
//  Diary
//
//  Created by Kobe, Moon on 2023/09/02.
//

import UIKit

final class DetailDiaryViewController: UIViewController {
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.keyboardDismissMode = .onDrag
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureDelegates()
    }
    
    private func configureDelegates() {
        diaryTextView.delegate = self
    }
}

extension DetailDiaryViewController {
    private func configureUI() {
        configureView()
        configureNavigationItem()
        addSubViews()
        diaryTextViewConstraints()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationItem() {
        navigationItem.title = DiaryDateFormatter.convertDate(Date(), Locale.current.identifier)
    }
    
    private func addSubViews() {
        view.addSubview(diaryTextView)
    }
    
    private func diaryTextViewConstraints() {
        diaryTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }
}

extension DetailDiaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.becomeFirstResponder()
    }
}
