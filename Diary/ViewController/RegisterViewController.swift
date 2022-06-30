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
    private let diaryViewModel = DiaryViewModel()
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
        diaryViewModel.checkDiaryData(title: detailView.titleField.text, body: detailView.descriptionView.text)
    }
}

// MARK: - Method

extension RegisterViewController {
    
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
        diaryViewModel.checkDiaryData(title: detailView.titleField.text, body: detailView.descriptionView.text)
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        diaryViewModel.checkDiaryData(title: detailView.titleField.text, body: detailView.descriptionView.text)
    }
}

