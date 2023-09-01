//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by kyungmin on 2023/08/30.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    private let diary: Diary
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
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
        
        setupComponents()
    }
}

// MARK: Setup Components
extension DiaryDetailViewController {
    private func setupComponents() {
        setupView()
        setupTextView()
        setupNavigationBar()
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupTextView() {
        diaryTextView.text = String(format: NameSpace.diaryText, diary.title, diary.body)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = diary.createdDate
    }
}

// MARK: Configure UI
extension DiaryDetailViewController {
    private func configureUI() {
        configureView()
    }
    
    private func configureView() {
        view.addSubview(diaryTextView)
    }
}

// MARK: Setup Constraint
extension DiaryDetailViewController {
    private func setupConstraint() {}
// MARK: Name Space
extension DiaryDetailViewController {
    private enum NameSpace {
        static let diaryText = "%@ \n\n %@"
    }
}
