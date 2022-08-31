//
//  DiaryListView.swift
//  Diary
//
//  Created by unchain, 웡빙 on 2022/08/17.
//

import UIKit

final class DiaryListView: UIView {
    // MARK: - Properties

    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DiaryListCell.self, forCellReuseIdentifier: NameSpace.cellIdentifier)
        return tableView
    }()
    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        adaptDataSource()
        setupSubviews()
        setupTableViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Methods

    private func adaptDataSource() {
        tableView.dataSource = self
    }
    
    private func setupSubviews() {
        self.addSubview(tableView)
    }
    
    private func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource

extension DiaryListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let diaryModelList = CoreDataManager.shared.reversedDiaries
        return diaryModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NameSpace.cellIdentifier,
                                                       for: indexPath) as? DiaryListCell else { return UITableViewCell() }
        let diaryModelList = CoreDataManager.shared.reversedDiaries
        let diaryModel = diaryModelList[indexPath.row]
        cell.setupData(with: diaryModel)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
