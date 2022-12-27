//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/21.
//

import UIKit

final class DiaryDetailViewController: RegisterDiaryViewController {
    
    private let diaryDetailView: DiaryDetailView = DiaryDetailView()
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
        self.view = diaryDetailView
        setupNavigationBar()
        configureDiary()
        setupNotification()
        diaryDetailView.addTextViewsDelegate(self)
    }
    
    private func configureDiary() {
        diaryDetailView.configureTitle(diaryPage.title)
        diaryDetailView.configureBody(diaryPage.body)
    }
}

extension DiaryDetailViewController {
    
    private func setupNavigationBar() {
        self.navigationItem.title = diaryPage.createdDate
    }
    
    override func textViewDidBeginEditing(_ textView: UITextView) {
        diaryDetailView.removePlaceHolder()
    }
    
    override func textViewDidEndEditing(_ textView: UITextView) {
        diaryDetailView.setupPlaceHolder()
    }
}
