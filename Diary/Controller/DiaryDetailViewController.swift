//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Zion, Serena on 2023/08/30.
//

import UIKit

protocol DiaryDetailViewControllerDelegate: AnyObject {
    func createDiaryData(text: String)
    func updateDiaryData(diaryEntity: DiaryEntity, text: String)
    func deleteDiaryData(diaryEntity: DiaryEntity)
    func popDiaryDetailViewController()
}

final class DiaryDetailViewController: UIViewController, AlertControllerShowable, ActivityViewControllerShowable {
    private lazy var textView: UITextView = {
        let textView = UITextView()
        
        textView.delegate = self
        textView.keyboardDismissMode = .onDrag
        textView.becomeFirstResponder()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private var diaryContent: DiaryContentsDTO
    private let date: String
    weak var delegate: DiaryDetailViewControllerDelegate?
    
    init(date: String, diaryContent: DiaryContentsDTO) {
        self.date = date
        self.diaryContent = diaryContent
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpConstraints()
        setUpViewController()
        setUpText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveDiaryContents()
        removeObserver()
    }
    
    private func configureUI() {
        view.addSubview(textView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }
    
    private func setUpViewController() {
        view.backgroundColor = .systemBackground
        navigationItem.title = date
        navigationItem.rightBarButtonItem = .init(title: "더보기", style: .plain, target: self, action: #selector(didTappedMoreButton))
    }
    
    private func setUpText() {
//        guard let diaryEntity else { return }
//
//        textView.text = diaryEntity.title + "\n" + diaryEntity.body
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(saveDiaryContents), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc
    private func saveDiaryContents() {
        let text = textView.text ?? ""
        
//        if isUpdate {
//            guard let diaryEntity else { return }
//
//            delegate?.updateDiaryData(diaryEntity: diaryEntity, text: text)
//        } else {
//            isUpdate = true
//            delegate?.createDiaryData(text: text)
//        }
    }
}

// MARK: - Button Action
extension DiaryDetailViewController {
    @objc
    private func didTappedMoreButton() {
        let shareAction = UIAlertAction(title: "Share...", style: .default) { _ in
            self.didTappedShareAction()
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.didTappedDeleteAction()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        showAlertController(actions: [shareAction, deleteAction, cancelAction])
    }
    
    private func didTappedDeleteAction() {
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
//            if let diaryEntity = self.diaryEntity {
//                self.delegate?.deleteDiaryData(diaryEntity: diaryEntity)
//            }
//            
//            self.textView.text = ""
//            self.delegate?.popDiaryDetailViewController()
        }
        
        showAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", style: .alert, actions: [cancelAction, deleteAction])
    }
    
    private func didTappedShareAction() {
        let sharedItem = self.textView.text
        
        self.showActivityViewController(items: [sharedItem as Any])
    }
}

// MARK: - TextView Delegate
extension DiaryDetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        saveDiaryContents()
    }
}
