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
    private var diary: DiaryEntity?
    private let indexPath: IndexPath?
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // MARK: - Initializer
    init(diary: DiaryEntity? = nil, container: PersistentContainer, indexPath: IndexPath? = nil) {
        self.diary = diary
        self.container = container
        self.indexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundColor()
        configureTitle()
        configureTextView()
        configureTextViewConstraint()
        fillTextView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
//        createDiary()
        wirteDiary()
        saveDiary()
    }
    
    // MARK: - Configure view
    private func configureBackgroundColor() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureTitle() {
        var date = Date()
        
        if let diary {
            date = diary.date
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.configureDiaryDateFormat()
        navigationItem.title = dateFormatter.string(from: date)
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
            return
        }
        
        contentTextView.text = diary.title + "\n" + (diary.body ?? "")
    }
    
    // 다이어리 작성
    private func wirteDiary() {
        if diary == nil {
            diary = DiaryEntity(context: container.viewContext)
            diary?.id = UUID()
            diary?.date = Date()
        }
        
        diary?.title = contentTextView.text.components(separatedBy: "\n")[0]
        
        if let range = contentTextView.text.range(of: "\n") {
            let body = contentTextView.text[range.upperBound...]
            diary?.body = String(body)
        }
    }
    
    // 다이어리 저장
    private func saveDiary() {
        container.saveContext()
    }
}
