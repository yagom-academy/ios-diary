//
//  EditingDiaryViewController.swift
//  Diary
//
//  Created by Mary & Whales on 2023/08/30.
//

import UIKit

final class EditingDiaryViewController: UIViewController, ActivityViewPresentable {
    private var diaryContent: DiaryContent
    
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.keyboardDismissMode = .onDrag
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    init(with diaryContent: DiaryContent) {
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
        
        ContainerManager.shared.delete(id: diaryContent.id)
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
            self.presentCheckDeleteAlert { _ in
                ContainerManager.shared.delete(id: self.diaryContent.id)
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
            ContainerManager.shared.insert(diaryContent: diaryContent)
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
        
        ContainerManager.shared.update(diaryContent: diaryContent)
    }
}

extension EditingDiaryViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        save()
    }
}
