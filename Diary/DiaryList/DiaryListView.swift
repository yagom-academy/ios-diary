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
    var diaryModels: [DiaryModel]?
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DiaryListCell.self, forCellReuseIdentifier: DiaryListCell.identifier)
        return tableView
    }()

    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(tableView)
        setTableViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Methods
    
    func setTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
