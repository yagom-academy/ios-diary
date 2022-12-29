//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/21.
//

import UIKit

final class DiaryDetailViewController: RegisterDiaryViewController {
    
    private let diaryPageView: DiaryDetailView
    private var diaryPage: DiaryPage
    
    override init(diaryPageView: DiaryDetailView = DiaryDetailView(), diary: DiaryPage) {
        self.diaryPageView = diaryPageView
        self.diaryPage = diary
        super.init(diaryPageView: diaryPageView, diary: diary)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDiary()
        diaryPageView.resignTitleTextViewFirstResponder()
        diaryPageView.resignFirstResponder()
    }
    
    private func configureDiary() {
        diaryPageView.configureTitle(diaryPage.title)
        diaryPageView.configureBody(diaryPage.body)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        let alphaBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(showActionSheet))
        
        self.navigationItem.rightBarButtonItem = alphaBarButtonItem
    }
}

extension DiaryDetailViewController {
    
    @objc private func showActionSheet() {
        let actionSheet = UIAlertController()
        actionSheet.addAction(UIAlertAction(title: "Share", style: .default) { _ in
            self.showActivityView()
        })
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.showDeleteAlert()
        })
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(actionSheet, animated: true)
    }
    
    private func showActivityView() {
        let title = diaryPage.title
        let body = diaryPage.body
        let activityViewController = CustomActivityViewController(activityItems: [title, body])
        
        self.present(activityViewController, animated: true)
    }
    
    private func showDeleteAlert() {
        let alertController = UIAlertController(title: "진짜요?",
                                                message: "정말로 삭제하시겠어요?",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
        alertController.addAction(UIAlertAction(title: "삭제", style: .destructive) { _ in
            CoreDataManager.shared.delete(self.diaryPage)
            self.navigationController?.popViewController(animated: true)
        })
        
        self.present(alertController, animated: true)
    }
}
