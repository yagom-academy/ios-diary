//
//  DataTaskViewController.swift
//  Diary
//
//  Created by 재재, 그루트 on 2022/09/01.
//

import UIKit

class DataTaskViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func saveDiaryData(diaryModel: DiaryModel, isExist: Bool) {
        if isExist == true {
            CoreDataManager.shared.update(diary: diaryModel)
            return
        }
        
        CoreDataManager.shared.create(newDiary: diaryModel)
    }
    
    func configureKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardShowAction),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDownAction),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func removeRegisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc func keyBoardShowAction(notification: NSNotification) {}
    
    @objc func keyboardDownAction() {}
}
