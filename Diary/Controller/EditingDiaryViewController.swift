//
//  EditingDiaryViewController.swift
//  Diary
//
//  Created by Mary & Whales on 2023/08/30.
//

import UIKit

final class EditingDiaryViewController: UIViewController, ActivityViewPresentable {
    private let diaryManager: DiaryEditable
    private let logger: Logger
    private var diaryContent: DiaryContent
    
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.keyboardDismissMode = .onDrag
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    init(diaryManager: DiaryEditable, logger: Logger, with diaryContent: DiaryContent) {
        self.diaryManager = diaryManager
        self.logger = logger
        self.diaryContent = diaryContent
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupDiaryTextView()
        setObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard diaryTextView.text.isEmpty else {
            save()
            return
        }
        
        deleteDiary(id: diaryContent.id)
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(diaryTextView)
        
        configureNavigationItem()
        setupConstraints()
    }
    
    private func configureNavigationItem() {
        let othersDiaryBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.bubble"),
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(tappedOthersButton))
        
        navigationItem.rightBarButtonItem = othersDiaryBarButtonItem
        navigationItem.title = diaryContent.date
    }
    
    @objc private func tappedOthersButton() {
        let shareHandler: (UIAlertAction) -> Void = { _ in
            let diaryContentItem = self.diaryContent.title + self.diaryContent.body
            self.presentActivityView(shareItem: diaryContentItem)
        }
        
        let deleteHandler: (UIAlertAction) -> Void = { _ in
            self.presentCheckDeleteAlert { [self] _ in
                deleteDiary(id: diaryContent.id)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        presentAlert(title: nil,
                     message: nil,
                     preferredStyle: .actionSheet,
                     actionConfigs: ("share".localized, .default, shareHandler),
                     ("delete".localized, .destructive, deleteHandler),
                     ("cancel".localized, .cancel, nil))
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            diaryTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func setupDiaryTextView() {
        if diaryContent.title.isEmpty == false || diaryContent.body.isEmpty == false {
            diaryTextView.text = diaryContent.title + diaryContent.body
        } else {
            diaryTextView.becomeFirstResponder()
            insertDiary(diaryContent: diaryContent)
        }
        
        addGesture()
        diaryTextView.delegate = self
    }
    
    private func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedTextView(_:)))
        diaryTextView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tappedTextView(_ sender: Any) {
        if diaryTextView.isFirstResponder {
            diaryTextView.resignFirstResponder()
        } else {
            diaryTextView.becomeFirstResponder()
        }
    }
    
    private func setObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enterBackground),
                                               name: UIWindowScene.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    @objc private func enterBackground() {
        save()
    }
    
    private func save() {
        guard let text = diaryTextView.text else { return }
        
        if let index = text.firstIndex(of: "\n") {
            diaryContent.title = String(text[text.startIndex ..< index])
            diaryContent.body = String(text[index ..< text.endIndex])
        } else {
            diaryContent.title = text
        }
        
        updateDiary(diaryContent: diaryContent)
    }
}

extension EditingDiaryViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        save()
    }
}

extension EditingDiaryViewController {
    private func deleteDiary(id: UUID) {
        do {
            try diaryManager.delete(id: id)
        } catch {
            logger.osLog(error.localizedDescription)
            presentAlert(title: "failedDeleteDataAlertTitle".localized,
                         message: "failedDeleteDataAlertMessage".localized,
                         preferredStyle: .alert,
                         actionConfigs: ("failedDeleteDataAlertAction".localized, .default, nil))
        }
    }
    
    private func insertDiary(diaryContent: DiaryContent) {
        do {
            try diaryManager.insert(diaryContent: diaryContent)
        } catch {
            logger.osLog(error.localizedDescription)
            presentAlert(title: "failedSaveDataAlertTitle".localized,
                         message: "failedSaveDataAlertMessage".localized,
                         preferredStyle: .alert,
                         actionConfigs: ("failedSaveDataAlertAction".localized, .default, nil))
        }
    }
    
    private func updateDiary(diaryContent: DiaryContent) {
        do {
            try diaryManager.update(diaryContent: diaryContent)
        } catch {
            logger.osLog(error.localizedDescription)
            presentAlert(title: "failedSaveDataAlertTitle".localized,
                         message: "failedSaveDataAlertMessage".localized,
                         preferredStyle: .alert,
                         actionConfigs: ("failedSaveDataAlertAction".localized, .default, nil))
        }
    }
}
