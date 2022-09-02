//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/08/25.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    
    private let diaryDetailView = DiaryDetailView()
    private var diayViewModel = DiaryViewModel()
    
    override func loadView() {
        self.view = diaryDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.diaryDetailView.diaryTextView.delegate = self
        self.setupNavigationbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.registerForKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeRegisterForKeyboardNotification()
    }
    
    func setIndexNumber(index: Int) {
        diayViewModel.index = index
    }
    
    private func setupNavigationbar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(didTapRightBarButton))
    }
    
    @objc private func didTapRightBarButton() {
        guard let index = diayViewModel.index else {
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
        guard let itemTitle = diayViewModel.itemTitle,
              let itemBody = diayViewModel.itemBody else {
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
                let id = self.diayViewModel.coreDataManager.fetchDiaryEntity()[index].id
                
                self.diayViewModel.coreDataManager.deleteDiary(id: id)
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
        guard let itemTitle = diayViewModel.itemTitle,
              let itemBody = diayViewModel.itemBody,
              let index = diayViewModel.index else {
            return
        }
        
        diayViewModel.coreDataManager.updateData(item: DiaryContent(id: diayViewModel.coreDataManager.fetchDiaryEntity()[index].id,
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
    
    func setData(data: DiaryContent) {
        self.navigationItem.title = data.createdAt.dateFormatted()
        diayViewModel.itemTitle = data.title
        diayViewModel.itemBody = data.body
        self.diaryDetailView.configure(with: data)
    }
}

extension DiaryDetailViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let diaryText = textView.text.components(separatedBy: "\n")
        let title = diaryText.first
        let body = diaryText[diaryText.startIndex + 1..<diaryText.endIndex].joined(separator: "")
        
        diayViewModel.itemTitle = title
        diayViewModel.itemBody = body
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        diayViewModel.realTimeTypingValue = text
        if diayViewModel.islineChanged {
            diaryDetailView.diaryTextView.typingAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        }
        return true
    }
}
