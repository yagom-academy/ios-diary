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
        setupNavigationBar()
        setupInitialView()
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
    
    private func setupNavigationBar() {
        let now = Date()
        navigationItem.title = now.timeIntervalSince1970.translateToDate()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: SystemName.moreViewIcon),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showActionSheet))
    }
    
    private func setupInitialView() {
        view.backgroundColor = .systemBackground
        view.addSubview(diaryView)
        setDiaryViewConstraint()
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
    
    private func generateAlertController(title: String?, message: String?, style: UIAlertController.Style, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { action in
            alert.addAction(action)
        }
        present(alert, animated: true)
    }
    
    private func generateShareAlertAction() -> UIAlertAction {
        let model = makeDiaryModel()
        let share = UIAlertAction(title: NameSpace.shareActionTitle, style: .default) { _ in
            let diaryToShare: [Any] = [MyActivityItemSource(title: model.title, text: model.body)]
            let activityViewController = UIActivityViewController(activityItems: diaryToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.diaryView
            
            self.present(activityViewController, animated: true)
        }
        return share
    }
    
    private func generateDeleteAlertAction() -> UIAlertAction {
        let delete = UIAlertAction(title: NameSpace.deleteActionTitle, style: .destructive) { _ in
            let cancel = UIAlertAction(title: NameSpace.cancel, style: .cancel)
            let delete = UIAlertAction(title: NameSpace.delete, style: .destructive) { [weak self] _ in
                guard let indexPath = self?.indexPath else { return }
                CoreDataManager.shared.delete(diary: CoreDataManager.shared.fetchedDiaries[indexPath.row])
                self?.navigationController?.popViewController(animated: true)
            }
            self.generateAlertController(title: NameSpace.deleteAlertTitle, message: NameSpace.deleteAlertMessage, style: .alert, actions: [cancel, delete])
        }
        return delete
    }
    
    private func generateCancelAlertAction() -> UIAlertAction {
        return UIAlertAction(title: NameSpace.cancelActionTitle, style: .cancel)
    }
    
    @objc private func showActionSheet() {
        let share = generateShareAlertAction()
        let delete = generateDeleteAlertAction()
        let cancel = generateCancelAlertAction()
        generateAlertController(title: nil, message: nil, style: .actionSheet, actions: [share, cancel, delete])
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
    
    private func makeDiaryModel() -> DiaryModel {
        let distinguishedTitleAndBody = diaryView.diaryTextView.text.components(separatedBy: NameSpace.twiceLineChange)
        let createdAt = Date().timeIntervalSince1970
        let filteredList = distinguishedTitleAndBody.filter { return $0 != NameSpace.whiteSpace && $0 != NameSpace.lineChange }
        guard filteredList.isEmpty == false else {
            let title = NameSpace.newDiary
            let body = NameSpace.whiteSpace
            return DiaryModel(title: String(title), body: String(body), createdAt: createdAt)
        }
        
        let title = distinguishedTitleAndBody[0]
        let body = distinguishedTitleAndBody.count == 1 ? NameSpace.whiteSpace : distinguishedTitleAndBody[1...distinguishedTitleAndBody.count-1].joined(separator: NameSpace.twiceLineChange)
        return DiaryModel(title: String(title), body: String(body), createdAt: createdAt)
    }
    
    @objc private func updateDiary() {
        guard let indexPath = indexPath else { return }
        let diaryModel = makeDiaryModel()
        CoreDataManager.shared.update(diary: diaryModel, with: indexPath)
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
        if mode == .create {
            diaryView.diaryTextView.becomeFirstResponder()
        }
    }
    
    @objc private func keyboardWillAppear(_ sender: Notification) {
        guard let userInfo = sender.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: keyboardFrame.size.height, right: .zero)
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
