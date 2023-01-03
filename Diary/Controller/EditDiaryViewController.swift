//
//  EditDiaryViewController.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/20.
//

import UIKit

final class EditDiaryViewController: UIViewController {
    private let editDiaryView = EditDiaryView()
    private var diaryModel: DiaryModel
    
    init(diaryModel: DiaryModel) {
        self.diaryModel = diaryModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = editDiaryView
        self.configureView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.setKeyboardHideObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.updateCurrentDiary()
    }
    
    private func configureView() {
        self.navigationItem.title = self.diaryModel.createdAt.convertDate()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(tappedActionButton))
        self.editDiaryView.configureView(with: self.diaryModel)
    }
    
    @objc private func tappedActionButton() {
        let actionSheet: UIAlertController = UIAlertController(title: nil,
                                                               message: nil,
                                                               preferredStyle: .actionSheet)
        let shareAction: UIAlertAction = makeShareAction()
        
        let deleteAction: UIAlertAction = makeDeleteAction()
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel",
                                                        style: .cancel)
        
        actionSheet.addAction(shareAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true)
    }
    
    private func makeShareAction() -> UIAlertAction {
        UIAlertAction(title: "Share...", style: .default) { _ in
            var objectsToShare: [String] = []
            objectsToShare.append(self.diaryModel.title + "\n" + self.diaryModel.body)
            self.showActivityContoller(objectsToShare)
        }
    }
    
    private func makeDeleteAction() -> UIAlertAction {
        UIAlertAction(title: "Delete", style: .destructive) { _ in
            let alert: UIAlertController = UIAlertController(title: "진짜요?",
                                                             message: "정말로 삭제하시겠어요?",
                                                             preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel)
            let deleteAction: UIAlertAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                do {
                    try CoreDataMananger.shared.delete(diary: self.diaryModel)
                } catch {
                    switch error {
                    case DiaryError.deleteFailed:
                        self.present(ErrorAlert.shared.showErrorAlert(
                            title: DiaryError.deleteFailed.alertTitle,
                            message: DiaryError.deleteFailed.alertMessage,
                            actionTitle: "확인"),
                                     animated: true)
                    case DiaryError.saveContextFailed:
                        self.present(ErrorAlert.shared.showErrorAlert(
                            title: DiaryError.saveContextFailed.alertTitle,
                            message: DiaryError.saveContextFailed.alertMessage,
                            actionTitle: "확인"),
                                     animated: true)
                    default:
                        break
                    }
                }
                
                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            self.present(alert, animated: true)
        }
    }
    
    private func setKeyboardHideObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardDidHide),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardDidHide() {
        self.updateCurrentDiary()
    }
    
    func updateCurrentDiary() {
        do {
            let newDiary: DiaryModel = createDiaryModel()
            try CoreDataMananger.shared.update(diary: newDiary)
        } catch {
            switch error {
            case DiaryError.updateFailed:
                self.present(ErrorAlert.shared.showErrorAlert(title: DiaryError.updateFailed.alertTitle,
                                                              message: DiaryError.updateFailed.alertMessage,
                                                              actionTitle: "확인"),
                             animated: true)
            case DiaryError.saveContextFailed:
                self.present(ErrorAlert.shared.showErrorAlert(title: DiaryError.saveContextFailed.alertTitle,
                                                              message: DiaryError.saveContextFailed.alertMessage,
                                                              actionTitle: "확인"),
                             animated: true)
            default:
                break
            }
        }
    }
    
    private func createDiaryModel() -> DiaryModel {
        let diaryContent = self.editDiaryView.fetchTextViewContent()
        
        if diaryContent.isEmpty {
            self.diaryModel.title = ""
            self.diaryModel.body = ""
        } else if diaryContent.contains("\n") {
            let splitedText = diaryContent.split(separator: "\n",
                                                 maxSplits: 1,
                                                 omittingEmptySubsequences: false)
            let title = String(splitedText[0])
            let body = String(splitedText[1])
            
            self.diaryModel.title = title
            self.diaryModel.body = body
        } else {
            self.diaryModel.title = diaryContent
            self.diaryModel.body = ""
        }
        
        return self.diaryModel
    }
}
