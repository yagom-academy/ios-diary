//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by 백곰, 주디 on 2022/08/17.
//

import UIKit

enum ViewMode {
    case add
    case edit
}

final class ManageDiaryViewController: UIViewController {
    private let manageDiaryView = ManageDiaryView()
    private var viewMode: ViewMode = .add
    private var id = UUID()
    
    override func loadView() {
        super.loadView()
        view = manageDiaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
        addNotificationObserver()
        checkViewMode()
    }
    
    func getDiaryData(data: DiaryItem) {
        let content = data.title + data.body
        manageDiaryView.fetchBodyTextView(content)
        id = data.id
        viewMode = .edit
        self.navigationItem.title = DateManager().formatted(date: Date(timeIntervalSince1970: data.createdAt))
    }
    
    private func configureBackButton() {
        let backBarButton = UIBarButtonItem(customView: backButton)
        backButton.addTarget(self, action: #selector(backButtonDidTapped), for: .touchUpInside)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = backBarButton
    }
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.setTitle(" 일기장", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.sizeToFit()

        return button
    }()
    
    private func checkViewMode() {
        switch viewMode {
        case .add:
            self.navigationItem.title = DateManager().formatted(date: Date())
            manageDiaryView.focusBodyTextView()
        case .edit:
            let optionButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(optionButtonDidTapped))
            navigationItem.rightBarButtonItem = optionButton
        }
    }
    
    @objc func backButtonDidTapped() {
        guard let diary = manageDiaryView.convertDiaryItem(with: id) else {
            checkSaveDiary()
            return
        }
        
        CoreDataManager.shared.saveDiary(item: diary)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveDiary() {
        guard let diary = manageDiaryView.convertDiaryItem(with: id) else { return}
        CoreDataManager.shared.saveDiary(item: diary)
    }
    
    private func checkSaveDiary() {
        let noticeMessage = viewMode == .add ? "생성" : "변경"
        let confirmAlert = UIAlertController(title: "Notice", message: "내용이 모두 입력되지 않아 \n일기장 \(noticeMessage)이 불가합니다. \n 그래도 나가시겠습니까?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "취소", style: .cancel)
        let yesAction = UIAlertAction(title: "나가기", style: .destructive) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        
        confirmAlert.addAction(noAction)
        confirmAlert.addAction(yesAction)
        self.present(confirmAlert, animated: true)
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveDiary), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    private func shareDiaryItem() {
        guard let shareText = manageDiaryView.convertDiaryItem(with: id) else { return }
        var shareObject = [Any]()
        
        shareObject.append(shareText.title + shareText.body)
        
        let activityViewController = UIActivityViewController(activityItems: shareObject, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func deleteDiaryItem() {
        let confirmAlert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "취소", style: .cancel)
        let yesAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            CoreDataManager.shared.deleteDiary(id: self.id)
            self.navigationController?.popViewController(animated: true)
        }
        
        confirmAlert.addAction(noAction)
        confirmAlert.addAction(yesAction)
        self.present(confirmAlert, animated: true)
    }
    
    @objc private func optionButtonDidTapped() {
        let optionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share...", style: .default) { _ in
            self.shareDiaryItem()
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteDiaryItem()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        [shareAction, deleteAction, cancelAction].forEach {
            optionAlert.addAction($0)
        }
        
        self.present(optionAlert, animated: true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        manageDiaryView.adjustContentInset(height: keyboardFrame.size.height)
    }
    
    @objc private func keyboardWillHide() {
        manageDiaryView.adjustContentInset(height: 0)
        saveDiary()
    }
}
