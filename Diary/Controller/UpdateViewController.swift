//
//  UpdateViewController.swift
//  Diary
//
//  Created by 김태현 on 2022/06/14.
//

import UIKit

final class UpdateViewController: UIViewController {
    private let textView = UITextView()
    private let keyboard = Keyboard()
    
    init(diaryData: DiaryData? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        setUpEditPage(diaryData: diaryData)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setUpView()
        setUpNavigationController(title: Formatter.getCurrentDate())
        setUpTextViewLayout()
        
        keyboard.setUpKeyboardNotification()
    }
    
    private func setUpEditPage(diaryData: DiaryData? = nil) {
        guard let diaryData = diaryData else {
            return
        }
        
        setUpNavigationController(title: diaryData.dateString)
        textView.text = "\(diaryData.title)\n\n\(diaryData.body)"
    }
    
    private func setUpNavigationController(title: String) {
        navigationItem.title = title
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setUpTextViewLayout() {
        view.addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
       
        keyboard.bottomContraint = textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            keyboard.bottomContraint
        ].compactMap { $0 })
    }
}
