//
//  DiaryFormViewController.swift
//  Diary
//  Created by inho, dragon on 2022/12/21.
//

import UIKit

final class DiaryFormViewController: UIViewController {
    private let diaryFormView = DiaryFormView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureDiaryViewLayout()
        configureNavigationBar()
    }
    
    private func configureDiaryViewLayout() {
        view.addSubview(diaryFormView)
        
        NSLayoutConstraint.activate([
            diaryFormView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryFormView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryFormView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            diaryFormView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        let date = Date()
        
        navigationItem.title = DateFormatter.koreanDateFormatter.string(from: date)
    }
}
