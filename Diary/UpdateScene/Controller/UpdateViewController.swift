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
    private let identifier: UUID?
    
    init(diaryData: DiaryDTO? = nil) {
        guard let diaryData = diaryData else {
            identifier = nil
            super.init(nibName: nil, bundle: nil)
            return
        }

        identifier = diaryData.identifier
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
        showKeyboard()
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setUpEditPage(diaryData: DiaryDTO) {
        setUpNavigationController(title: diaryData.dateString)
        textView.text = "\(diaryData.title)\n\n\(diaryData.body ?? "")"
    }
    
    private func setUpNavigationController(title: String) {
        navigationItem.title = title
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "일기장", style: .plain, target: self, action: #selector(saveData))
    }
    
    @objc private func saveData() {
        let splitedText = textView.text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: false)
            .map {
                String($0)
            }
                
        guard let title = splitedText.first,
              let body = splitedText.last,
              let date = Formatter.getDate(from: navigationItem.title ?? "") else {
            return
        }
        
        if let identifier = identifier {
            let edittedData = DiaryDTO(identifier: identifier, title: title, body: body, date: date)
            
            DiaryDAO.shared.update(userData: edittedData)
        } else {
            let newData = DiaryDTO(title: title, body: body, date: date)

            DiaryDAO.shared.create(userData: newData)
        }
        
        navigationController?.popViewController(animated: true)
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
    
    private func showKeyboard() {
        textView.becomeFirstResponder()
    }
}

