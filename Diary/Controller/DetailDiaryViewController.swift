//
//  DetailDiaryViewController.swift
//  Diary
//
//  Created by Jinah Park on 2023/04/25.
//

import UIKit

final class DetailDiaryViewController: UIViewController {
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        
        return textField
    }()
    
    private let bodyTextField: UITextField = {
        let textField = UITextField()
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSubview()
        configureConstraint()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        title = Date().convertDate()
    }
    
    private func configureSubview() {
        view.addSubview(contentStackView)
        contentStackView.addArrangedSubview(titleTextField)
        contentStackView.addArrangedSubview(bodyTextField)
    }
    
    private func configureConstraint() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
