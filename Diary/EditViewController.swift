//
//  AddViewController.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/20.
//

import UIKit

final class EditViewController: UIViewController {
    var status: Status?
    
    enum Status {
        case new
        case edit
    }
    
    private let editView = EditDiaryView()
    private let coreDataManager = CoreDataManager.shared
    private let currentDate = Date()
    private var diaryData: DiaryData?
    
    init(diaryData: DiaryData?, status: Status) {
        super.init(nibName: nil, bundle: nil)
        self.diaryData = diaryData
        self.status = status
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.saveEditData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if status == .new {
            editView.presentKeyboard()
        }
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
        }
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(shareButtonTapped))
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
}

// MARK: - Action
extension EditViewController {
    @objc private func shareButtonTapped() {
        //TODO: 추후 구현
    }
    
    private func saveEditData() {
        let data = editView.packageData()
        switch data {
        case .success(let data):
            if diaryData == nil {
                coreDataManager.saveData(titleText: data.title,
                                         contentText: data.content,
                                         date: currentDate,
                                         completion: nil)
            } else {
                guard let id = diaryData?.id else { return }
                coreDataManager.updateData(id: id,
                                           titleText: data.title,
                                           contentText: data.content,
                                           completion: nil)
            }
        case .failure(let error):
            self.showCustomAlert(alertText: "저장 실패하였습니다.",
                                 alertMessage: error.errorDescription ?? "",
                                 bool: false,
                                 completion: nil)
        }
    }
}
