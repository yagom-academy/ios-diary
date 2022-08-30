//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 민쏜, 보리사랑 on 2022/08/16.
//

import UIKit

final class DiaryUpdateViewController: DiaryEditableViewController {
    
    // MARK: - Properties
    
    private var diaryItem: DiaryItem?
    
    private lazy var rightBarButtonActionSheet: UIAlertController = {
        let rightBarButtonActionSheet = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let share = UIAlertAction(
            title: "공유",
            style: .default,
            handler: { action in
                self.convertTextToDiaryItem()
                
                let sharedDiaryItem = self.createTextViewContent()
                
                let activitiViewController = UIActivityViewController(
                    activityItems: [sharedDiaryItem],
                    applicationActivities: nil
                )
                self.present(activitiViewController, animated: true)
            }
        )
        
        let cancel = UIAlertAction(
            title: "취소",
            style: .cancel
        )
        
        let delete = UIAlertAction(
            title: "삭제",
            style: .destructive,
            handler: { action in
                self.present(self.deleteAlert, animated: true)
                self.deleteDiary()
                self.navigationController?.popViewController(animated: true)
            }
        )
        
        [share, cancel, delete].forEach {
            rightBarButtonActionSheet.addAction($0)
        }

        return rightBarButtonActionSheet
    }()
    
    private lazy var deleteAlert: UIAlertController = {
        let deleteAlert = UIAlertController(
            title: "정말 삭제할까요?",
            message: "삭제 후 복구는 불가능합니다.",
            preferredStyle: .alert
        )

        let cancel = UIAlertAction(
            title: "취소",
            style: .cancel
        )
        
        let delete = UIAlertAction(
            title: "삭제",
            style: .destructive,
            handler: { action in
                self.deleteDiary()
                self.navigationController?.popViewController(animated: true)
            }
        )
        
        [cancel, delete].forEach {
            deleteAlert.addAction($0)
        }

        return deleteAlert
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRootViewUI()
        addUIComponents()
        configureLayout()
        
        setupKeyboardWillShowNoification()
        
        setupContentViewData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardWillShowNoification()
        
        saveDiary()
    }
}

extension DiaryUpdateViewController {
    
    // MARK: - Methods
    
    func receiveData(_ diaryItem: DiaryItem?) {
        self.diaryItem = diaryItem
    }
}

private extension DiaryUpdateViewController {
    
    // MARK: - Private Methods
    
    // MARK: - Configuring DiaryItem for Core Data
    
    func convertTextToDiaryItem() {
        let data = splitTitleAndBody(from: contentTextView.text)
        
        diaryItem?.title = data.title
        diaryItem?.body = data.body
    }
    
    func saveDiary() {
        convertTextToDiaryItem()
        
        guard let diaryItem = diaryItem else {
            return
        }
        
        DiaryCoreDataManager.shared.update(diaryItem: diaryItem)
    }
    
    func deleteDiary() {
        guard let diaryItem = diaryItem else {
            return
        }
        
        DiaryCoreDataManager.shared.delete(diaryItem: diaryItem)
        self.diaryItem = nil
    }
    
    // MARK: Configuring UI
    
    func configureRootViewUI() {
        self.view.backgroundColor = .systemBackground
        
        if let diaryItem = diaryItem {
            navigationItem.title = diaryItem.createdDate.localizedFormat()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(rightBarButtonDidTap)
        )
    }
    
    @objc func rightBarButtonDidTap() {
        showActionSheet()
    }
    
    @objc private func showActionSheet() {
        present(rightBarButtonActionSheet, animated: true)
    }

    // MARK: Configuring Model
    
    func setupContentViewData() {
        let currentDiaryContent = createTextViewContent()
        displayDiaryDetailData(with: currentDiaryContent)
    }
    
    func displayDiaryDetailData(with textViewContent: String) {
        contentTextView.text = textViewContent
    }
    
    func createTextViewContent() -> String {
        guard let diaryItem = diaryItem else {
            return ""
        }
        
        return """
        \(diaryItem.title)
        
        \(diaryItem.body)
        """
    }
}
