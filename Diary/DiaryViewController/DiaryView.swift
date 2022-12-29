//
//  DiaryView.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/20.
//

import UIKit

final class DiaryView: UIView {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        self.addSubview(tableView)
        configureConstraints()
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func configureTableView(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        self.tableView.register(DiaryListCell.self, forCellReuseIdentifier: DiaryListCell.identifier)
        self.tableView.dataSource = dataSource
        self.tableView.delegate = delegate
    }
    
    func updateT() {
        tableView.reloadData()
    }
}
