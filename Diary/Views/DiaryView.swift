//
//  DiaryTableView.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/16.
//

import UIKit

class DiaryView: UIView {
    
    // MARK: Properties
    
    var tableView = UITableView()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureTableView()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func configureTableView() {
        tableView = UITableView(frame: bounds,
                                style: .plain)
        
        addSubview(tableView)
    }

    
    private func configureUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
