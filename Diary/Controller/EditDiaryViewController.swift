//
//  EditDiaryViewController.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/20.
//

import UIKit

class EditDiaryViewController: UIViewController {
    private let editDiaryView = EditDiaryView()
    private var tmpDiaryModel: DiaryModel = DiaryModel()
    var diaryModel: DiaryModel!
    
    override func loadView() {
        self.view = editDiaryView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        CoreDataMananger.shared.updateDiary(createDiaryModel(with: editDiaryView.fetchTextViewContent()))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    func configureView(with diaryData: DiaryModel) {
        self.navigationItem.title = diaryData.createdAt.convertDate()
        self.editDiaryView.configureView(with: diaryData)
        self.diaryModel = diaryData
    }
    
    func createDiaryModel(with diaryContent: String) -> DiaryModel {
        if diaryContent == "" {
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

        return diaryModel
    }
}
