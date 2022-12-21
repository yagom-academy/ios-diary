//
//  DiaryViewController.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2022/12/21.
//

import UIKit

class DiaryViewController: UIViewController {
    let diary: Diary
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    let titleTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleTextView, bodyTextView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    init(diary: Diary) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureHierarchy()
        configureView(with: diary)
        configureLayout()
    }
    
    func configureHierarchy() {
        scrollView.addSubview(containerStackView)
        view.addSubview(scrollView)
    }
    
    func configureView(with diary: Diary) {
        navigationItem.title = diary.createdDate.localeFormattedText
        titleTextView.text = diary.title
        bodyTextView.text = diary.body
    }
    
    func configureLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        
            containerStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            containerStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
}
