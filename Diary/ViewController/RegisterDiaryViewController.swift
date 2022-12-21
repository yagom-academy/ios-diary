//
//  RegisterDiaryViewController.swift
//  Diary
//
//  Created by 맹선아 on 2022/12/21.
//

import UIKit

class RegisterDiaryViewController: UIViewController {
    private let diaryDetailView: DiaryDetailView = DiaryDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = diaryDetailView
    }
}
