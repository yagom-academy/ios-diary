//
//  DiaryFormViewController.swift
//  Diary
//
//  Created by yonggeun Kim on 2022/12/21.
//

import UIKit

final class DiaryFormViewController: UIViewController {
    private let diaryFormView = DiaryFormView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = diaryFormView
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        let date = Date()
        
        navigationItem.title = DateFormatter.koreanDateFormatter.string(from: date)
    }
}
