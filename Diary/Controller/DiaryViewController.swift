//
//  DiaryViewController.swift
//  Diary
//
//  Created by Erick on 2023/08/30.
//

import UIKit

protocol DiaryViewControllerDelegate: AnyObject {
    func diaryViewController(_ diaryViewController: DiaryViewController, updateDiary isSuccess: Bool)
}

final class DiaryViewController: UIViewController, AppResignObservable {
    
    // MARK: - Private Property
    private let diaryManager: DiaryManageable
    private var diaryEntry: DiaryEntry?
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.addObserveKeyboardNotification()
        
        return textView
    }()
    
    // MARK: - Property
    weak var delegate: DiaryViewControllerDelegate?
    
    // MARK: - Life Cycle
    init(diaryManager: DiaryManageable, diaryEntry: DiaryEntry?) {
        self.diaryManager = diaryManager
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
        addObserveWillResignActive(observer: self, selector: #selector(endEditingAndPop))
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
        setupTextView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationItem() {
        if diaryEntry == nil {
            let completButton = UIBarButtonItem(title: NameSpace.done, style: .plain, target: self, action: #selector(endEditingAndPop))
            navigationItem.title = DateFormatManager.dateString(localeDateFormatter: UserDateFormatter.shared)
            navigationItem.rightBarButtonItem = completButton
        } else {
            let moreButton = UIBarButtonItem(image: UIImage(systemName: NameSpace.ellipsis), style: .plain, target: self, action: #selector(presentMoreActionSheet))
            navigationItem.title = diaryEntry?.creationDate
            navigationItem.rightBarButtonItem = moreButton
        }
    }
    
    private func setupTextView() {
        textView.delegate = self
        
        if diaryEntry == nil {
            textView.becomeFirstResponder()
        }
    }
}

// MARK: - Push & Present Controller
extension DiaryViewController {
    @objc private func presentMoreActionSheet() {
        let shareAction = UIAlertAction(title: NameSpace.share, style: .default) { _ in
            guard let diaryEntry = self.diaryEntry else {
                self.presentFailAlert()
                return
            }
            
            ActivityViewManager.presentActivityView(to: self, with: diaryEntry)
        }
        let deleteAction = UIAlertAction(title: NameSpace.delete, style: .destructive) { _ in
            guard let diaryEntry = self.diaryEntry else {
                self.presentFailAlert()
                return
            }
            
            self.presentDeleteAlert(diaryEntry: diaryEntry)
        }
        let cancelAction = UIAlertAction(title: NameSpace.cancel, style: .cancel)
        let actionSheet = UIAlertController.customAlert(alertTile: nil, alertMessage: nil, preferredStyle: .actionSheet, alertActions: [shareAction, deleteAction, cancelAction])
        
        present(actionSheet, animated: true)
    }
    
    private func presentDeleteAlert(diaryEntry: DiaryEntry) {
        AlertManager.presentDeleteAlert(to: self) { [weak self] _ in
            guard let self else {
                return
            }
            
            do {
                try diaryManager.deleteDiary(diaryEntry)
                delegate?.diaryViewController(self, updateDiary: true)
                navigationController?.popViewController(animated: true)
            } catch {
                presentFailAlert()
            }
        }
    }
    
    private func presentFailAlert() {
        AlertManager.presentFailAlert(to: self, with: NameSpace.failMessage)
    }
}

// MARK: - TextView Delegate
extension DiaryViewController: UITextViewDelegate {
    @objc private func endEditingAndPop() {
        textView.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let diaryContents = textView.text.components(separatedBy: NameSpace.enter).filter { $0.isEmpty == false }
        
        if diaryContents.isEmpty {
            return
        }
        
        guard let title = diaryContents.first else {
            return
        }
        
        let body = diaryContents.dropFirst().joined(separator: NameSpace.enter)
        
        do {
            if var diaryEntry {
                diaryEntry.title = title
                diaryEntry.body = body
                try diaryManager.storeDiary(diaryEntry)
                delegate?.diaryViewController(self, updateDiary: true)
            } else {
                let diaryEntry = DiaryEntry(title: title, body: body)
                try diaryManager.storeDiary(diaryEntry)
                delegate?.diaryViewController(self, updateDiary: true)
            }
        } catch {
            self.presentFailAlert()
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
        static let share = "share..."
        static let delete = "Delete"
        static let cancel = "Cancel"
        static let done = "완료"
        static let ellipsis = "ellipsis"
        static let enter = "\n"
        static let diaryFormat = "%@\n%@"
        static let failMessage = "작업에 실패했습니다."
    }
}
