//
//  Diary - DiaryListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    // MARK: - Properties
    
    private let diaryListView = DiaryListView(frame: .zero)
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
        view.backgroundColor = .systemBackground
        diaryListView.tableView.dataSource = self
        configureDiaryListView()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = NameSpace.diary
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(addButtonDidTapped))
    }

    @objc func addButtonDidTapped() {
        navigationController?.pushViewController(DiaryViewController(), animated: true)
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
    
    private func configureDiaryListView() {
        view.addSubview(diaryListView)
        diaryListView.translatesAutoresizingMaskIntoConstraints = false
        diaryListView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        diaryListView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        diaryListView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        diaryListView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
