//
//  DiaryViewController.swift
//  Diary
//
//  Created by Erick on 2023/08/30.
//

import UIKit

final class DiaryViewController: UIViewController {
    
    // MARK: - Private Property
    private let diaryStore: DiaryStorageProtocol
    private let diaryEntry: DiaryEntry?
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.addObserveKeyboardNotification()
        
        return textView
    }()
    
    // MARK: - Life Cycle
    init(diaryStore: DiaryStorageProtocol, diaryEntry: DiaryEntry?) {
        self.diaryStore = diaryStore
        self.diaryEntry = diaryEntry
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentTextView()
        setupUIObject()
        configureUI()
        setupConstraints()
    }
}

// MARK: - Setup Data
extension DiaryViewController {
    private func setupContentTextView() {
        if let diaryEntry = diaryEntry {
            textView.text = String(format: NameSpace.diaryFormat, diaryEntry.title, diaryEntry.body)
        }
    }
}

// MARK: - Setup UI Object
extension DiaryViewController {
    private func setupUIObject() {
        setupView()
        setupNavigationItem()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationItem() {
        if let diaryEntry = diaryEntry {
            navigationItem.title = diaryEntry.creationDate
        } else {
            navigationItem.title = DateFormatManager.dateString(localeDateFormatter: UserDateFormatter.shared)
        }
    }
}

// MARK: - Configure UI
extension DiaryViewController {
    private func configureUI() {
        configureView()
    }
    
    private func configureView() {
        view.addSubview(textView)
    }
}

// MARK: - Setup Constraint
extension DiaryViewController {
    private func setupConstraints() {
        setupTextViewConstraint()
    }
    
    private func setupTextViewConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            textView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}

// MARK: - Name Space
extension DiaryViewController {
    private enum NameSpace {
        static let diaryFormat = "%@ \n\n %@"
    }
}
