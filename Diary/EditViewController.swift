//
//  AddViewController.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/20.
//

import UIKit

final class EditViewController: UIViewController {
    private let editView = EditDiaryView()
    private let coreDataManager = CoreDataManager.shared
    private let currentDate = Date()
    private var diaryData: DiaryData?
    
    init(diaryData: DiaryData?) {
        super.init(nibName: nil, bundle: nil)
        self.diaryData = diaryData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = editView
        self.editView.bindData(diaryData)
        setNavigation()
    }
    
    private func setNavigation() {
        if let date = diaryData?.createdAt {
            self.title = Formatter.changeCustomDate(date)
        } else {
            self.title = Formatter.changeCustomDate(currentDate)
            editView.presentKeyboard()
        }
        
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                 target: self,
                                                 action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc private func doneButtonTapped() {
        let data = editView.packageData()
        switch data {
        case .success(let data):
            if diaryData == nil {
                coreDataManager.saveData(titleText: data.title,
                                         contentText: data.content,
                                         date: currentDate) {
                    self.showCustomAlert(alertText: "저장 성공",
                                         alertMessage: "저장성공하였습니다.",
                                         bool: true) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } else {
                guard let id = diaryData?.id else { return }
                coreDataManager.updateData(id: id,
                                           titleText: data.title,
                                           contentText: data.content) {
                    self.showCustomAlert(alertText: "편집 성공",
                                         alertMessage: "편집성공하였습니다.",
                                         bool: true) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        case .failure(let error):
            self.showCustomAlert(alertText: "저장 실패하였습니다.",
                                 alertMessage: error.errorDescription ?? "",
                                 bool: false,
                                 completion: nil)
        }
    }
}
