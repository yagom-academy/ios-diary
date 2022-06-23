//
//  DetailViewController.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/15.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private lazy var detailView = DetailView(frame: view.frame)
    private let persistenceManager = PersistenceManager.shared
    private var diaryData: DiaryModel
    
    override func loadView() {
        super.loadView()
        detailView.backgroundColor = .systemBackground
        self.view = detailView
    }
    
    init(diaryData: DiaryModel) {
        self.diaryData = diaryData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarTitle()
        detailView.setUpView(diaryData: diaryData)
        registerKeyboardNotifications()
        setNavigationBarRightButton()
    }
}

// MARK: - Method

extension DetailViewController {
    
    private func setNavigationBarTitle() {
        navigationItem.title = diaryData.createdAt.formattedDate
    }
    
    private func setNavigationBarRightButton() {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(navigationBarRightButtonTapped)
        )
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func navigationBarRightButtonTapped() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let share = UIAlertAction(title: "Share...", style: .default) { [weak self] _ in
            guard let title = self?.detailView.titleField.text else { return }
            let activityViewController = UIActivityViewController(activityItems: [title], applicationActivities: nil)
            self?.present(activityViewController, animated: true)
        }
        let delete = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            let deleteAlert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            let delete = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
                guard let diaryData = self?.diaryData else {
                    return
                }
                self?.persistenceManager.delete(diary: diaryData)
                self?.navigationController?.popViewController(animated: true)
            }
            deleteAlert.addAction(delete)
            deleteAlert.addAction(cancel)
            self?.present(deleteAlert, animated: true)
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        sheet.addAction(cancel)
        sheet.addAction(share)
        sheet.addAction(delete)
        present(sheet, animated: true)
        
    }
}

// MARK: - Keyboard Method

extension DetailViewController {
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
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
        updateListData()
    }
    
    private func updateListData() {
        let title = detailView.titleField.text
        let body = detailView.descriptionView.text
        
        diaryData = DiaryModel(title: title, body: body, createdAt: diaryData.createdAt, id: diaryData.id)
        
        persistenceManager.update(diary: diaryData)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateListData()
    }
}
