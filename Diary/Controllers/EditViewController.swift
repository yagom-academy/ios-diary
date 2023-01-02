//
//  AddViewController.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/20.
//

import UIKit

protocol KeyboardActionSavable: AnyObject {
    func saveWhenHideKeyboard()
}

final class EditViewController: UIViewController {
    private lazy var editView = EditDiaryView(diaryData: diaryData)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.checkToSave()
        self.checkToDelete()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = editView
        self.editView.delegate = self
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

// MARK: - Associate Save, Delete Logic
extension EditViewController {
    @objc func saveWhenBackground() {
        self.checkToSave()
    }
    
    private func checkToSave() {
        let data = editView.packageData()
        if let diaryData = diaryData {
            guard let id = diaryData.id else { return }
            do {
                try coreDataManager.updateData(id: id, contentText: data)
            } catch {
                guard let error = error as? DataError else { return }
                self.showCustomAlert(alertText: error.localizedDescription,
                                     alertMessage: error.errorDescription ?? "",
                                     useAction: true,
                                     completion: nil)
            }
        } else {
            do {
                self.diaryData = try coreDataManager.saveData(contentText: data, date: currentDate)
            } catch {
                guard let error = error as? DataError else { return }
                self.showCustomAlert(alertText: error.localizedDescription,
                                     alertMessage: error.errorDescription ?? "",
                                     useAction: true,
                                     completion: nil)
            }
        }
    }
    
    private func checkToDelete() {
        guard let data = diaryData,
              let contentText = diaryData?.contentText?.trimmingCharacters(
                in: .whitespacesAndNewlines) else { return }
        
        if let id = data.id, contentText.count == .zero {
            do {
                try coreDataManager.deleteData(id: id)
            } catch {
                guard let error = error as? DataError else { return }
                self.showCustomAlert(alertText: error.localizedDescription,
                                     alertMessage: "삭제 실패하였습니다.",
                                     useAction: true,
                                     completion: nil)
            }
        }
    }
}

// MARK: - Action
extension EditViewController {
    @objc private func optionButtonTapped() {
        self.checkToSave()
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            self.moveToActivityView(data: self.diaryData)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            guard let id = self.diaryData?.id else { return }
            
            do {
                try self.coreDataManager.deleteData(id: id)
            } catch {
                guard let error = error as? DataError else { return }
                self.showCustomAlert(alertText: error.localizedDescription,
                                     alertMessage: "삭제 실패하였습니다.",
                                     useAction: true,
                                     completion: nil)
            }
            self.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        [shareAction, deleteAction, cancelAction].forEach {
            alert.addAction($0)
        }
        self.present(alert, animated: true)
    }
}

extension EditViewController: KeyboardActionSavable {
    func saveWhenHideKeyboard() {
        self.checkToSave()
    }
}
