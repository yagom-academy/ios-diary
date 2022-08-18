//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 재재, 그루트 on 2022/08/18.
//

import UIKit

class DiaryDetailViewController: UIViewController {
    // MARK: - properties
    
    private let diaryDetailView = DiaryDetailView()
    private var diaryDetailData: DiaryTestData?
    
    // MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureView()
        configureViewLayout()
        configureDetailViewItem()
    }
    
    // MARK: - methods
    
    private func configureView() {
        view.addSubview(diaryDetailView)
        navigationItem.title = diaryDetailData?.createdAt.convertDate()
    }
    
    private func configureViewLayout() {
        NSLayoutConstraint.activate([
            diaryDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            diaryDetailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryDetailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureDetailViewItem() {
        guard let title = diaryDetailData?.title,
              let body = diaryDetailData?.body else { return }
        
        diaryDetailView.configureDetailTextView(ofText: "\(title)\n\n\(body)")
    }
}

// MARK: - extension

extension DiaryDetailViewController: DataSendable {
    func dataTask<T>(data: T) {
        diaryDetailData = data as? DiaryTestData
    }
}
