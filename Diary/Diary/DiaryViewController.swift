//
//  DiaryViewController.swift
//  Diary
//
//  Created by unchain, 웡빙 on 2022/08/17.
//

import UIKit

final class DiaryViewController: UIViewController {
    // MARK: - Properties
    
    let diaryView = DiaryView(frame: .zero)
    var indexPath: IndexPath?
    var mode: PageMode?
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        setupNavigationTitle()
        setupKeyboard()
        setupNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showUpKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        performAppropriateMode()
    }
    
    // MARK: - UI Methods
    
    private func setupInitialView() {
        view.backgroundColor = .systemBackground
        view.addSubview(diaryView)
        setDiaryViewConstraint()
    }
    
    private func setupNavigationTitle() {
        let now = Date()
        navigationItem.title = now.timeIntervalSince1970.translateToDate()
    }
    
    private func setDiaryViewConstraint() {
        diaryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            diaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            diaryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: - CoreDataManager Methods

extension DiaryViewController {
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateDiary), name: .update, object: nil)
    }
    
    private func performAppropriateMode() {
        switch mode {
        case .create:
            createDiary()
        case .modify:
            modifyDiary()
        default:
            return
        }
    }
    
    private func createDiary() {
        guard diaryView.diaryTextView.text.isEmpty == false else { return }
        let diaryModel = makeDiaryModel()
        CoreDataManager.shared.createDiary(with: diaryModel)
    }
    
    private func modifyDiary() {
        guard let indexPath = indexPath else { return }
        if diaryView.diaryTextView.text.isEmpty || diaryView.diaryTextView.text == NameSpace.placeHolder {
            CoreDataManager.shared.delete(diary: CoreDataManager.shared.fetchedDiaries[indexPath.row])
        } else {
            updateDiary()
        }
    }
    
    @objc private func updateDiary() {
        guard let indexPath = indexPath else { return }
        let diaryModel = makeDiaryModel()
        CoreDataManager.shared.update(diary: diaryModel, with: indexPath.row)
    }
    
    private func makeDiaryModel() -> DiaryModel {
        let distinguishedTitleAndBody = diaryView.diaryTextView.text.split(separator: "\n", maxSplits: 1)
        let createdAt = Date().timeIntervalSince1970
        
        guard distinguishedTitleAndBody.count != 0 else {
            let title = "새로운일기장"
            let body = ""
            return DiaryModel(title: String(title), body: String(body), createdAt: createdAt)
        }
        
        let title = distinguishedTitleAndBody[0]
        let body = distinguishedTitleAndBody.count == 1 ? "" : distinguishedTitleAndBody[1]
        return DiaryModel(title: String(title), body: String(body), createdAt: createdAt)
    }
}

// MARK: - Keyboard Methods

extension DiaryViewController {
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillAppear),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillDisAppear),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        diaryView.closeButton.addTarget(self,
                                        action: #selector(hideKeyboard),
                                        for: .touchUpInside)
    }
    
    private func showUpKeyboard() {
        diaryView.diaryTextView.becomeFirstResponder()
    }
    
    @objc private func keyboardWillAppear(_ sender: Notification) {
        guard let userInfo = sender.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.size.height, right: 0.0)
        diaryView.diaryTextView.contentInset = contentInset
        diaryView.diaryTextView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillDisAppear(_ sender: Notification) {
        let contentInset = UIEdgeInsets.zero
        diaryView.diaryTextView.contentInset = contentInset
        diaryView.diaryTextView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
        updateDiary()
    }
}
