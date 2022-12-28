//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/20.
//

import UIKit

final class AddDiaryViewController: UIViewController {
    private let addDiaryView = AddDiaryView()
    
    override func loadView() {
        self.view = addDiaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = DateFormatter().longDate
        self.view.backgroundColor = UIColor.white
        self.setKeyboardHideObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        CoreDataMananger.shared.insertDiary(createDiaryModel())
    }
    
    func createDiaryModel() -> DiaryModel {
        let diaryContent = self.addDiaryView.fetchTextViewContent()
        guard diaryContent != "" else {
            return DiaryModel()
        }
        
        if diaryContent.contains("\n") {
            let splitedText = diaryContent.split(separator: "\n",
                                                 maxSplits: 1,
                                                 omittingEmptySubsequences: false)
            
            let title = String(splitedText[0])
            let body = String(splitedText[1])
            
            return DiaryModel(title: title, body: body)
        } else {
            return DiaryModel(title: diaryContent)
        }
    }
    
    func setKeyboardHideObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardDidHide),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardDidHide() {
        CoreDataMananger.shared.insertDiary(createDiaryModel())
    }
}
