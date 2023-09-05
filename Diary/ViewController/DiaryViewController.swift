//
//  DiaryViewController.swift
//  Diary
//
//  Created by MINT, BMO on 2023/08/30.
//

import UIKit

final class DiaryViewController: UIViewController {
    // MARK: - Property
    private let container: PersistentContainer
    private let diary: DiaryEntity?
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    private var hasTitleLine: Bool {
        return contentTextView.text.contains("\n")
    }
    
    // MARK: - Initializer
    init(diary: DiaryEntity? = nil, container: PersistentContainer) {
        self.diary = diary
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextView.delegate = self
        configureBackgroundColor()
        configureTextView()
        configureTextViewConstraint()
        fillTextView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        createDiary()
        saveDiary()
    }
    
    // MARK: - Configure view
    private func configureBackgroundColor() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureTextView() {
        view.addSubview(contentTextView)
    }
    
    private func configureTextViewConstraint() {
        NSLayoutConstraint.activate([
            contentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }
    
    // MARK: - Method
    private func fillTextView() {
        guard let diary else {
            let dateFormatter = DateFormatter()
            
            dateFormatter.configureDiaryDateFormat()
            navigationItem.title = dateFormatter.string(from: Date())
            
            return
        }
        
        contentTextView.text = diary.title! + "\n\n" + diary.body!
        navigationItem.title = diary.date?.description
    }
    
    // 다이어리 생성
    private func createDiary() {
        let diary = DiaryEntity(context: container.viewContext)
        diary.title = "샘플 타이틀"
        diary.body = "샘플 내용입니다."
        diary.date = Date()
    }
    
    // 다이어리 저장
    private func saveDiary() {
        container.saveContext()
    }
}

// MARK: - UITextViewDelegate
extension DiaryViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if hasTitleLine == false && text == "\n" {
            contentTextView.text += "\n"
        }
        
        return true
    }
}
