//
//  MainDiaryView.swift
//  Diary
//  Created by inho, dragon on 2022/12/20.
//

import UIKit

final class MainDiaryView: UIView {
    // MARK: Properties
    
    private let diaryTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomDiaryCell.self, forCellReuseIdentifier: CustomDiaryCell.identifier)
        return tableView
    }()
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal Methods
    
    func reloadTableView() {
        diaryTableView.reloadData()
    }
    
    func setUpTableView(with mainViewController: MainViewController) {
        diaryTableView.delegate = mainViewController
        diaryTableView.dataSource = mainViewController
    }
    
    // MARK: Private Methods
    
    private func configureLayout() {
        addSubview(diaryTableView)
        
        NSLayoutConstraint.activate([
            diaryTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            diaryTableView.topAnchor.constraint(equalTo: topAnchor),
            diaryTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            diaryTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
