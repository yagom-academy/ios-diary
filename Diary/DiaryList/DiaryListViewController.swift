//
//  Diary - DiaryListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    // MARK: - Properties
    
    private let diaryListView = DiaryListView(frame: .zero)

    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupDiaryListView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateData),
                                               name: .changeDiaries,
                                               object: nil)
    }
    
    // MARK: - Methods

    private func setupDiaryListView() {
        diaryListView.diaryModels = CoreDataManager.shared.fetchedDiaries
        configureDiaryListView()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = NameSpace.diary
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(addButtonDidTapped))
    }
    
    private func configureDiaryListView() {
        view.addSubview(diaryListView)
        diaryListView.translatesAutoresizingMaskIntoConstraints = false
        diaryListView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        diaryListView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        diaryListView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        diaryListView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    @objc func addButtonDidTapped() {
        navigationController?.pushViewController(DiaryViewController(), animated: true)
        CoreDataManager.shared.saveDiary(with: DiaryModel(title: "test", body: "", createdAt: 1608651333))
    }
    
    @objc func updateData() {
        diaryListView.diaryModels = CoreDataManager.shared.fetchedDiaries
        diaryListView.tableView.reloadData()
    }
}
