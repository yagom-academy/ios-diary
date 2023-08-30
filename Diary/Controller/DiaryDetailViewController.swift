//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by kyungmin on 2023/08/30.
//

import UIKit

final class DiaryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
    }
}

// MARK: Setup Components
extension DiaryDetailViewController {
    private func setupComponents() {
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
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
