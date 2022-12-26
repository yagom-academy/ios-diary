//
//  RegisterDiaryViewController.swift
//  Diary
//
//  Created by 맹선아 on 2022/12/21.
//

import UIKit

class RegisterDiaryViewController: UIViewController {
    private let diaryDetailView: DiaryDetailView = DiaryDetailView()
    private var diaryCoreDataManager = CoreDataManager.shared
    private var diaryPage = DiaryPage(title: " ", body: " ", createdAt: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = diaryDetailView
        diaryCoreDataManager.saveDiary(diaryPage)
        setupNotification()
        diaryDetailView.addTextViewsDelegate(self)
    }
}

extension RegisterDiaryViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        diaryDetailView.removePlaceHolder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        diaryDetailView.setupPlaceHolder()
    }
}
