//
//  MainView.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/14.
//

import UIKit

final class MainView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    convenience init(frame: CGRect, delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        self.init(frame: frame)
        self.baseTableView.delegate = delegate
        self.baseTableView.dataSource = dataSource
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let baseTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private func setUpView() {
        addSubviews()
        makeConstraints()
        registerCellIdentifier()
        backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        addSubview(baseTableView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            baseTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            baseTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            baseTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            baseTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func registerCellIdentifier() {
        baseTableView.register(DiaryCell.self, forCellReuseIdentifier: DiaryCell.identifier)
    }
}
