//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/20.
//

import UIKit

final class AddDiaryViewController: UIViewController {
    let addDiaryView = AddDiaryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = addDiaryView
        self.navigationItem.title = DateFormatter().longDate
        
        self.setKeyboardObserver()
    }
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.addDiaryView.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.addDiaryView.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo: NSDictionary = notification.userInfo as? NSDictionary else { return }
        
        guard let keyboardFrame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else { return }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        self.textView.contentInset.bottom += keyboardHeight
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
    }
}
