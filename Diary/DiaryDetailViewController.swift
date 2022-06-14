//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by safari, Eddy on 2022/06/14.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    private let mainView = DiaryDetailView()
    private let diary: Diary
    
    init(diary: Diary) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        mainView.configure(diary: diary)
        configureLayout()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        title = diary.createdAt?.time()
    }
    
    private func configureLayout() {
        self.view.addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
