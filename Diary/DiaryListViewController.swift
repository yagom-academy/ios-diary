//
//  Diary - DiaryListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class DiaryListViewController: UIViewController {
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
        return tableView
    }()
    private var diaryModelList: [DiaryModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureTableView()
        diaryModelList = JsonParser.fetchData()
    }
    
    private func configureNavigationBar() {
        self.navigationItem.title = "일기장"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(addButtonDidTapped))
    }

    private func configureTableView() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    @objc func addButtonDidTapped() {
        self.navigationController?.pushViewController(DiaryViewController(), animated: true)
    }
}

extension DiaryListViewController: UITableViewDelegate {
    
}

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let diaryModelList = diaryModelList else { return 0 }
        return diaryModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.identifier,
                                                       for: indexPath) as? DiaryTableViewCell else { return UITableViewCell() }
        guard let diaryModelList = diaryModelList else { return UITableViewCell() }
        let diaryModel = diaryModelList[indexPath.row]
        cell.setData(with: diaryModel)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
