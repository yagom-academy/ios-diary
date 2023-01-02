//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/21.
//

import UIKit

final class DiaryDetailViewController: RegisterDiaryViewController {
    
    private let diaryDetailView: DiaryDetailView
    private var diaryInfo: DiaryInfo
    
    override init(diaryDetailView: DiaryDetailView = DiaryDetailView(), diaryInfo: DiaryInfo) {
        self.diaryDetailView = diaryDetailView
        self.diaryInfo = diaryInfo
        super.init(diaryDetailView: diaryDetailView, diaryInfo: diaryInfo)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDiary()
        diaryDetailView.resignTitleTextViewFirstResponder()
        diaryDetailView.resignFirstResponder()
    }
    
    private func configureDiary() {
        diaryDetailView.configureTitle(diaryInfo.title)
        diaryDetailView.configureBody(diaryInfo.body)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        let alphaBarButtonItem = UIBarButtonItem(image: UIImage(systemName: Constant.shareIcon),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(showActionSheet))
        
        self.navigationItem.rightBarButtonItem = alphaBarButtonItem
    }
}

extension DiaryDetailViewController {
    
    @objc private func showActionSheet() {
        let actionSheet = UIAlertController()
        actionSheet.addAction(UIAlertAction(title: Constant.actionSheetShareTitle,
                                            style: .default) { _ in
            self.showActivityView()
        })
        actionSheet.addAction(UIAlertAction(title: Constant.actionSheetDeleteTitle,
                                            style: .destructive) { _ in
            self.showDeleteAlert()
        })
        actionSheet.addAction(UIAlertAction(title: Constant.actionSheetCancelTitle,
                                            style: .cancel))
        
        self.present(actionSheet, animated: true)
    }
    
    private func showActivityView() {
        let title = diaryInfo.title
        let body = diaryInfo.body
        let activityViewController = CustomActivityViewController(activityItems: [title, body])
        
        self.present(activityViewController, animated: true)
    }
    
    private func showDeleteAlert() {
        let alertController = UIAlertController(title: Constant.deleteAlertTitle,
                                                message: Constant.deleteAlertMessage,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constant.alertActionCancelTitle,
                                                style: .cancel))
        alertController.addAction(UIAlertAction(title: Constant.alertActionOkTitle,
                                                style: .destructive) { _ in
            CoreDataManager.shared.delete(self.diaryInfo)
            self.navigationController?.popViewController(animated: true)
        })
        
        self.present(alertController, animated: true)
    }
}

extension DiaryDetailViewController {

    private enum Constant {
        static let actionSheetShareTitle = "Share"
        static let actionSheetDeleteTitle = "Delete"
        static let actionSheetCancelTitle = "Cancel"
        static let shareIcon = "square.and.arrow.up"
        static let deleteAlertTitle = "진짜요?"
        static let deleteAlertMessage = "정말로 삭제하시겠어요?"
        static let alertActionCancelTitle = "취소"
        static let alertActionOkTitle = "삭제"
    }
}
