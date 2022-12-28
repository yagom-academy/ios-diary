//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/21.
//

import UIKit

final class DiaryDetailViewController: RegisterDiaryViewController {
    
    private var diaryPage: DiaryPage
    
    init(diary: DiaryPage) {
        self.diaryPage = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureDiary()
        setupNotification()
        diaryPageView.addTextViewsDelegate(self)
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

    @objc func showActionSheet() {
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
            CoreDataManager.shared.deleteDiary(self.diaryPage)
        })
        
        self.present(alertController, animated: true)
    }
}
