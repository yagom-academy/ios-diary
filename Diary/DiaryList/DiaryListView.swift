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
        tableView.register(DiaryListCell.self, forCellReuseIdentifier: DiaryListCell.identifier)
        return tableView
    }()

    // MARK: - Initializer
    
    init(_ rootViewController: UIViewController) {
        super.init(frame: .zero)
        configureTableView(rootViewController)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Methods

    private func configureTableView(_ rootViewController: UIViewController) {
        rootViewController.view.addSubview(tableView)

        tableView.topAnchor.constraint(equalTo: rootViewController.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: rootViewController.view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: rootViewController.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: rootViewController.view.trailingAnchor).isActive = true
    }
}
