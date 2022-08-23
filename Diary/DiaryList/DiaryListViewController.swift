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
        configureDiaryListView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        diaryListView.tableView.reloadData()
    }

    // MARK: - Methods
    
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
    }
}
