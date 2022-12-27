//
//  EditDiaryViewController.swift
//  Diary
//
//  Created by 유연수 on 2022/12/27.
//

import UIKit

class EditDiaryViewController: UIViewController {
    private let editDiaryView = EditDiaryView()
    
    override func loadView() {
        self.view = editDiaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    func configureView(with diaryData: DiaryModel) {
        self.navigationItem.title = diaryData.createdAt.description
        self.editDiaryView.configureView(with: diaryData)
    }
}
