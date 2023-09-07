//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by hoon, karen on 2023/08/30.
//

import UIKit
import CoreData

final class DiaryDetailViewController: UIViewController {
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
        saveDiary()
    }
    
    init(title: String = "", body: String = "", date: Date = Date()) {
        self.diaryTitle = title
        self.diaryBody = body
        self.diaryDate = date
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DiaryDetailViewController {
    func saveDiary() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Diary", in: managedContext) else {
            return
        }
        
        guard let diary = NSManagedObject(entity: entity, insertInto: managedContext) as? Diary else {
            return
        }
        
        diary.setValue(titleTextView.text, forKeyPath: "title")
        diary.setValue(bodyTextView.text, forKeyPath: "body")
        diary.setValue(diaryDate, forKeyPath: "date")
                
        appDelegate.saveContext()
    }
}

private extension DiaryDetailViewController {
    func configure() {
        configureRootView()
        configureNavigation()
        configureSubviews()
        configureContents()
        configureContentStackView()
        configureConstraints()
    }
    
    func configureRootView() {
        view.backgroundColor = .systemBackground
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
