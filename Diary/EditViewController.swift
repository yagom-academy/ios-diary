//
//  AddViewController.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/20.
//

import UIKit

protocol KeyboardActionProtocol {
    func saveWhenHideKeyboard()
}

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
        self.editView.keyboardDelegate = self
        setNavigation()
        addNotification()
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
    
    private func addNotification() {
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(saveWhenBackground),
                                                   name: UIScene.willDeactivateNotification,
                                                   object: nil)
        } else {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(saveWhenBackground),
                                                   name: UIApplication.willResignActiveNotification,
                                                   object: nil)
        }
    }
    
    @objc func saveWhenBackground() {
        saveEditData()
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
            if status == .new {
                coreDataManager.saveData(titleText: data.title,
                                         contentText: data.content,
                                         date: currentDate) { result in
                    switch result {
                    case .success(let data):
                        self.diaryData = data
                    case .failure(let error):
                        self.showCustomAlert(alertText: error.localizedDescription,
                                             alertMessage: error.errorDescription ?? "",
                                             useAction: true,
                                             completion: nil)
                    }
                }
            } else {
                guard let id = diaryData?.id else { return }
                coreDataManager.updateData(id: id,
                                           titleText: data.title,
                                           contentText: data.content) { _ in }
            }
        case .failure(let error):
            self.showCustomAlert(alertText: "저장 실패",
                                 alertMessage: error.errorDescription ?? "",
                                 completion: nil)
        }
    }
}

extension EditViewController: KeyboardActionProtocol {
    func saveWhenHideKeyboard() {
        if status == .new {
            saveEditData()
            status = .edit
        } else {
            saveEditData()
        }
    }
}
