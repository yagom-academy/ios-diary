//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Kiwi, Brad on 2022/08/25.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    
    private let diaryDetailView = DiaryDetailView()
    private let coreDataManager = CoreDataManager.shared
    private var itemTitle: String?
    private var itemBody: String?
    private var index: Int?
    
    override func loadView() {
        self.view = diaryDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.diaryDetailView.diaryTextView.delegate = self
        self.setNavigationbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.registerForKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeRegisterForKeyboardNotification()
    }
    
    func getIndexNumber(index: Int) {
        self.index = index
    }
    
    private func setNavigationbar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(didTapRightBarButton))
    }

    @objc private func didTapRightBarButton() {
        guard let index = self.index else {
            return
        }

        let sheet = UIAlertController(title: .none,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        self.cancelAlertAction(sheet)
        self.sharedAlertAction(sheet)
        self.deleteAlertAction(sheet, index)
        self.present(sheet, animated: true)
    }
    
    private func cancelAlertAction(_ sheet: UIAlertController) {
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
    
    private func sharedAlertAction(_ sheet: UIAlertController) {
        guard let itemTitle = itemTitle,
              let itemBody = itemBody else {
            return
        }
        
        sheet.addAction(UIAlertAction(title: "Shared..", style: .default, handler: { _ in
            let shareObject = [itemTitle + ("\n") + itemBody]
            let activityViewController = UIActivityViewController(activityItems: shareObject, applicationActivities: nil)
            
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }))
    }
    
    private func deleteAlertAction(_ sheet: UIAlertController, _ index: Int) {
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            let alert = UIAlertController(title: "진짜요?",
                                          message: "정말로 삭제하시겠어요?",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "취소", style: .default, handler: { _ in
                
            }))
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
                self.coreDataManager.deleteDiary(id: self.coreDataManager.fetchDiaryEntity()[index].id)
                self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(alert, animated: true)
        }))
    }
    
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardDownAction),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeRegisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    private func updateDiaryData() {
        guard let itemTitle = itemTitle,
              let itemBody = itemBody,
              let index = index else {
            return
        }
        
        coreDataManager.updateData(item: DiaryContent(id: coreDataManager.fetchDiaryEntity()[index].id,
                                                      title: itemTitle,
                                                      body: itemBody,
                                                      createdAt: Date().timeIntervalSince1970))
    }
    
    @objc private func keyBoardShow(notification: NSNotification) {
        guard let userInfo: NSDictionary = notification.userInfo as? NSDictionary,
              let keyboardFrame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else {
            return
        }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        self.diaryDetailView.changeTextViewBottomAutoLayout(keyboardHeight)
    }
    
    @objc private func keyBoardDownAction(_ sender: Notification) {
        self.diaryDetailView.changeTextViewBottomAutoLayout()
        self.updateDiaryData()
    }
    
    func loadData(data: DiaryContent) {
        self.navigationItem.title = data.createdAt.dateFormatted()
        self.itemTitle = data.title
        self.itemBody = data.body
        self.diaryDetailView.configure(with: data)
    }
}

extension DiaryDetailViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let diaryText = textView.text.components(separatedBy: "\n")
        let title = diaryText.first
        let body = diaryText[diaryText.startIndex + 1..<diaryText.endIndex].joined(separator: "")
        
        self.itemTitle = title
        self.itemBody = body
    }
}
