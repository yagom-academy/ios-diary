//
//  AddDairyViewController.swift
//  Diary
//
//  Created by Zion, Serena on 2023/08/30.
//

import UIKit

final class AddDairyViewController: UIViewController {
    private lazy var textView: UITextView = {
        let textView = UITextView()
        
        textView.text = diaryTitle + "\n\n" + diaryDescription
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let diaryTitle: String
    private let diaryDescription: String
    
    init(diaryTitle: String, diaryDescription: String) {
        self.diaryTitle = diaryTitle
        self.diaryDescription = diaryDescription
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpConstraints()
        setUpViewController()
    }
    
    private func configureUI() {
        view.addSubview(textView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }
    
    private func setUpViewController() {
        view.backgroundColor = .systemBackground
        navigationItem.title = convertFormattedTodayDate()
    }
    
    private func convertFormattedTodayDate() -> String {
        let todayDate = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.string(from: todayDate)
    }
}
