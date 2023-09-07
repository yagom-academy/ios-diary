//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by hoon, karen on 2023/08/30.
//

import UIKit
import CoreData

final class DiaryDetailViewController: UIViewController {
    private let diary: Diary
    private let diaryTitle: String
    private let diaryBody: String
    private let diaryDate: Date
    
    private let titleTextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.adjustsFontForContentSizeCategory = true
        textView.font = .preferredFont(forTextStyle: .body)

        return textView
    }()
    
    private let bodyTextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.adjustsFontForContentSizeCategory = true
        textView.font = .preferredFont(forTextStyle: .body)
        
        return textView
    }()
    
    private let contentStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        chooseSaveOrUpdate()
    }
    
    init(diary: Diary, title: String = "", body: String = "", date: Date = Date()) {
        self.diary = diary
        self.diaryTitle = title
        self.diaryBody = body
        self.diaryDate = date
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DiaryDetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        chooseSaveOrUpdate()
    }
}

private extension DiaryDetailViewController {
    func chooseSaveOrUpdate() {
        if diaryTitle != "" && titleTextView.text != diaryTitle {
            updateDiary()
        } else if diaryTitle == "" && titleTextView.text != diaryTitle {
            saveDiary()
        }
    }
    
    func saveDiary() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        
        diary.setValue(titleTextView.text, forKeyPath: "title")
        diary.setValue(bodyTextView.text, forKeyPath: "body")
        diary.setValue(diaryDate, forKeyPath: "date")
                
        appDelegate.saveContext()
    }
    
    func updateDiary() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        diary.setValue(titleTextView.text, forKeyPath: "title")
        diary.setValue(bodyTextView.text, forKeyPath: "body")
        
        do {
            try managedContext.save()
        } catch {
            print("error")
        }
    }
}

private extension DiaryDetailViewController {
    func configure() {
        configureRootView()
        configureTextView()
        configureNavigation()
        configureSubviews()
        configureContents()
        configureContentStackView()
        configureConstraints()
    }
    
    func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    func configureTextView() {
        titleTextView.delegate = self
        bodyTextView.delegate = self
    }
    
    func configureNavigation() {
        navigationItem.title = DateFormatter.diaryFormatter.string(from: diaryDate)
    }
    
    func configureSubviews() {
        view.addSubview(contentStackView)
    }
    
    func configureContents() {
        titleTextView.text = diaryTitle
        bodyTextView.text = diaryBody
    }
    
    func configureContentStackView() {
        contentStackView.addArrangedSubview(titleTextView)
        contentStackView.addArrangedSubview(bodyTextView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }
}
