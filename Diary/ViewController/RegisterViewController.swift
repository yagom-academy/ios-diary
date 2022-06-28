//
//  RegisterViewController.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/17.
//

import UIKit

fileprivate extension DiaryConstants {
    static let emptyString = ""
}

final class RegisterViewController: UIViewController {
    private var diaryModel: DiaryModel?
    private let persistenceManager = DiaryEntityManager.shared
    private lazy var detailView = DetailView(frame: view.frame)
}

// MARK: - View Life Cycle Method

extension RegisterViewController {
    
    override func loadView() {
        super.loadView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        registerDidEnterBackgroundNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailView.titleField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        checkDiaryData()
    }
}

// MARK: - Method

extension RegisterViewController {
    
    private func createDiaryData() {
        let title = detailView.titleField.text
        let body = detailView.descriptionView.text
        if title == DiaryConstants.emptyString && body == DiaryConstants.emptyString {
            return
        } else {
            persistenceManager.create(
                diary: DiaryModel(
                    title: title,
                    body: body,
                    createdAt: Date(),
                    id: UUID().uuidString
                )
            )
        }
    }
    
    private func updateDiaryData() {
        let title = detailView.titleField.text
        let body = detailView.descriptionView.text
        guard let diary = diaryModel else {
            return
        }
        if title == DiaryConstants.emptyString && body == DiaryConstants.emptyString {
            return
        } else {
            persistenceManager.update(
                diary: DiaryModel(
                    title: title,
                    body: body,
                    createdAt: Date(),
                    id: diary.id
                )
            )
        }
    }
    
    private func checkDiaryData() {
        if diaryModel == nil {
            createDiaryData()
        } else {
            updateDiaryData()
        }
    }
    
    private func registerDidEnterBackgroundNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
}

// MARK: - Action Method

extension RegisterViewController {
    
    @objc private func didEnterBackground() {
        checkDiaryData()
    }
}

// MARK: - Keyboard Method

extension RegisterViewController {

     @objc private func keyboardWillShow(notification: NSNotification) {
         guard let keyboardSize = (
             notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
         )?.cgRectValue else {
             return
         }
         detailView.mainScrollView.contentInset.bottom = keyboardSize.height
     }
     
     @objc private func keyboardWillHide(notification: NSNotification) {
         detailView.mainScrollView.contentInset.bottom = .zero
         checkDiaryData()
     }
}
