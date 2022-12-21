//
//  DiaryFormViewController.swift
//  Diary
//
//  Created by yonggeun Kim on 2022/12/21.
//

import UIKit

class DiaryFormViewController: UIViewController {
    let diaryFormView = DiaryFormView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = diaryFormView
    }
}
