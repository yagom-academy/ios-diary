//
//  DiaryView.swift
//  Diary
//
//  Created by 김태현 on 2022/06/28.
//

import UIKit

final class DiaryView: UIView {
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()
    
    init(delegate: UITableViewDelegate) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        setUpTableView(delegate: delegate)
        
        registerCell()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTableView(delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }
    
    private func registerCell() {
        tableView.register(DiaryCell.self)
        tableView.register(UITableViewCell.self)
    }
    
    private func layout() {
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func getTableView() -> UITableView {
        return tableView
    }
    
    func setUpTableView(refresh: UIRefreshControl) {
        tableView.refreshControl = refresh
    }
}
