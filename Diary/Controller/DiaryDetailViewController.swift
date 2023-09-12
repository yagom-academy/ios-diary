//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Zion, Serena on 2023/08/30.
//

import UIKit

protocol DiaryDetailViewControllerDelegate: AnyObject {
    func createDiaryData(text: String)
    func updateDiaryData()
}

final class DiaryDetailViewController: UIViewController, AlertControllerShowable, ActivityViewControllerShowable {
    private let textView: UITextView = {
        let textView = UITextView()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private var diaryEntity: DiaryEntity?
    weak var delegate: DiaryDetailViewControllerDelegate?
    
    init(diaryEntity: DiaryEntity? = nil) {
        self.diaryEntity = diaryEntity
        
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveDiaryContents()
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
        navigationItem.rightBarButtonItem = .init(title: "더보기", style: .plain, target: self, action: #selector(didTappedMoreButton))
    }
    
    private func saveDiaryContents() {
        if diaryEntity == nil {
            let text = textView.text ?? ""
            
            delegate?.createDiaryData(text: text)
        } else {
            delegate?.updateDiaryData()
        }
    }
}

// MARK: - Button Action
extension DiaryDetailViewController {
    @objc
    func didTappedMoreButton() {
        let shareAction = UIAlertAction(title: "Share...", style: .default) { _ in
            self.showActivityViewController(items: [""])
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
            
        }
        
        showAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", style: .alert, actions: [cancelAction, deleteAction])
    }
}
