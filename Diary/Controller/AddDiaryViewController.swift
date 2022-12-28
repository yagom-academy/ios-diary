//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/20.
//

import UIKit
import CoreData

final class AddDiaryViewController: UIViewController, AddKeyboardNotification {
    private let addDiaryView = AddDiaryView()
    
    override func loadView() {
        self.view = addDiaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = DateFormatter().longDate
        self.view.backgroundColor = UIColor.white
        self.setKeyboardObserver()
        self.initializeHideKeyBoard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        CoreDataMananger.shared.insertDiary(createDiaryModel())
    }
    
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardHeight = getKeyboardHeight(from: notification) else { return }
        
        self.addDiaryView.changeTextViewContentInset(for: keyboardHeight)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        guard let keyboardHeight = getKeyboardHeight(from: notification) else { return }
        
        self.addDiaryView.changeTextViewContentInset(for: -keyboardHeight)
    }
    
    private func initializeHideKeyBoard() {
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self,
                                                              action: #selector(self.dismissKeyBoard))
        self.navigationController?.navigationBar.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyBoard() {
        self.addDiaryView.endEditing(true)
    }
    
    func createDiaryModel() -> DiaryModel {
        let diaryContent = self.addDiaryView.fetchTextViewContent()
        guard diaryContent != "" else {
            return DiaryModel()
        }
        let splitedText = diaryContent.split(separator: "\n",
                                             maxSplits: 1,
                                             omittingEmptySubsequences: false)
        
        let title = String(splitedText[0])
        let body = String(splitedText[1])
        
        return DiaryModel(title: title, body: body)
    }
}
