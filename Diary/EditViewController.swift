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
                                                 action: #selector(optionButtonTapped))
        
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
}

// MARK: - Associate Save Logic
extension EditViewController {
    @objc func saveWhenBackground() {
        self.saveEditData()
    }
    
    private func changeStatusToSave() {
        if status == .new {
            saveEditData()
            status = .edit
        } else {
            saveEditData()
        }
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


// MARK: - Action
extension EditViewController {
    @objc private func optionButtonTapped() {
        changeStatusToSave()
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            self.moveToActivityView()
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            guard let id = self.diaryData?.id else { return }
            
            self.coreDataManager.deleteData(id: id) { result in
                if !result {
                    self.showCustomAlert(alertText: "삭제 실패",
                                         alertMessage: "삭제 실패하였습니다.",
                                         completion: nil)
                }
                
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        [shareAction, deleteAction, cancelAction].forEach {
            alert.addAction($0)
        }
        self.present(alert, animated: true)
    }
    
    private func moveToActivityView() {
        guard let sendingText = self.diaryData?.contentText else { return }
        let activiyController = UIActivityViewController(activityItems: [sendingText],
                                                         applicationActivities: nil)
        activiyController.excludedActivityTypes = [.addToReadingList,
                                                   .assignToContact,
                                                   .openInIBooks,
                                                   .saveToCameraRoll]
        
        self.present(activiyController, animated: true, completion: nil)
    }
}

extension EditViewController: KeyboardActionProtocol {
    func saveWhenHideKeyboard() {
        changeStatusToSave()
    }
}
