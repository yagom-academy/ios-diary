//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/20.
//

import UIKit

final class AddDiaryViewController: UIViewController {
    private let addDiaryView = AddDiaryView()
    private var tmpDiaryModel: DiaryModel = DiaryModel()
    
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
        
        addDiaryCoreData()
    }
    
    func setKeyboardHideObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardDidHide),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardDidHide() {
        addDiaryCoreData()
    }
    
    func addDiaryCoreData() {
        let tmpDiaryModelContent = tmpDiaryModel.title + "\n" + tmpDiaryModel.body
        let diaryContent = self.addDiaryView.fetchTextViewContent()
        
        guard tmpDiaryModelContent != diaryContent else { return }
        
        CoreDataMananger.shared.insertDiary(createDiaryModel(with: diaryContent))
    }
    
    func createDiaryModel(with diaryContent: String) -> DiaryModel {
        if diaryContent == "" {
            tmpDiaryModel = DiaryModel()
        } else if diaryContent.contains("\n") {
            let splitedText = diaryContent.split(separator: "\n",
                                                 maxSplits: 1,
                                                 omittingEmptySubsequences: false)
            let title = String(splitedText[0])
            let body = String(splitedText[1])
            
            tmpDiaryModel = DiaryModel(title: title, body: body)
        } else {
            tmpDiaryModel = DiaryModel(title: diaryContent)
        }
        
        return tmpDiaryModel
    }
}
