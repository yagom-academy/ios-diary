//
//  DiaryEditViewController.swift
//  Diary
//
//  Created by Christy, vetto on 2023/04/25.
//

import UIKit

final class DiaryEditViewController: UIViewController {
    let textView: UITextView = {
        let textView = UITextView()
        
        textView.font = .preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.keyboardDismissMode = .onDrag
        
        configureUI()
    }
    
    init(diaryItem: DiaryItem? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        guard let diaryItem else { return }
        
        textView.text = diaryItem.body
        navigationItem.title = DateManger.shared.convertToDate(fromInt: diaryItem.createDate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
