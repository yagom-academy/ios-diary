//
//  RegisterViewController.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/17.
//

import UIKit

final class RegisterViewController: UIViewController {
    private let persistenceManager = PersistenceManager.shared
    private lazy var detailView = DetailView(frame: view.frame)

    override func loadView() {
        super.loadView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackGround), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc private func didEnterBackGround() {
        createDiaryData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        createDiaryData()
    }
    
    private func createDiaryData() {
        let title = detailView.titleField.text
        let body = detailView.descriptionView.text
        persistenceManager.create(diary: DiaryModel(title: title, body: body, createdAt: Date(), id: UUID().uuidString))
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        )?.cgRectValue else { return }
        detailView.mainScrollView.contentInset = .init(
            top: .zero,
            left: .zero,
            bottom: keyboardSize.height,
            right: .zero
        )
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        detailView.mainScrollView.contentInset = .init(
            top: .zero,
            left: .zero,
            bottom: .zero,
            right: .zero
        )
        createDiaryData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        detailView.titleField.becomeFirstResponder()
    }
}
