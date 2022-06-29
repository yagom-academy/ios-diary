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
    private lazy var detailView = DetailView(frame: view.frame)
    private let diaryModelManger: DiaryModelManger = DiaryModelManger()
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
        registerKeyboardNotifications()
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
        guard let title = detailView.titleField.text else {
            return
        }
        guard let body = detailView.descriptionView.text else {
            return
        }
        if title == DiaryConstants.emptyString && body == DiaryConstants.emptyString {
            return
        } else {
            diaryModelManger.create(
                title: title,
                body: body,
                createdAt: Date(),
                id: UUID().uuidString
            )
        }
    }
    
    private func updateDiaryData() {
        guard let title = detailView.titleField.text, let body = detailView.descriptionView.text else {
            return
        }
        guard let diary = diaryModel else {
            return
        }
        if title == DiaryConstants.emptyString && body == DiaryConstants.emptyString {
            return
        } else {
            diaryModelManger.update(
                    title: title,
                    body: body,
                    createdAt: Date(),
                    id: diary.id
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
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        checkDiaryData()
    }
}

