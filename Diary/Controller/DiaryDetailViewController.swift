//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by kyungmin on 2023/08/30.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
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
        
        setupComponents()
    }
}

// MARK: Setup Components
extension DiaryDetailViewController {
    private func setupComponents() {
        setupView()
        setupNavigationBar()
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        navigationItem.title = diary.createdDate
    }
}

// MARK: Configure UI
extension DiaryDetailViewController {
    private func configureUI() {}
    
    private func configureContentView() {}
}

// MARK: Setup Constraint
extension DiaryDetailViewController {
    private func setupConstraint() {}
}
