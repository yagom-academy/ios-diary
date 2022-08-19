//
//  Diary - DiaryListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    // MARK: - Properties

    private var diaryListView: DiaryListView?
    private var diaryModelList: [DiaryModel]?

    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        diaryModelList = JsonParser.fetchData()
        setupDiaryListView()
    }
    
    // MARK: - Methods

    private func setupDiaryListView() {
        self.view.backgroundColor = .systemBackground
        diaryListView = DiaryListView(self)
        diaryListView?.tableView.dataSource = self
    }
    
    private func configureNavigationBar() {
        self.navigationItem.title = NameSpace.diary
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(addButtonDidTapped))
    }

    @objc func addButtonDidTapped() {
        self.navigationController?.pushViewController(DiaryViewController(), animated: true)
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let diaryModelList = diaryModelList else { return 0 }
        return diaryModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryListCell.identifier,
                                                       for: indexPath) as? DiaryListCell else { return UITableViewCell() }
        guard let diaryModelList = diaryModelList else { return UITableViewCell() }
        let diaryModel = diaryModelList[indexPath.row]
        cell.setData(with: diaryModel)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
