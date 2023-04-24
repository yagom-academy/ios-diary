//
//  Diary - ViewController.swift
//  Created by Rhode, 무리.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {
    
    let diaryListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(DiaryListCell.self, forCellReuseIdentifier: DiaryListCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    let diaryListCell: DiaryListCell = {
        let cell = DiaryListCell()
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(diaryListTableView)
        
        configureConstraint()
    }
    
    private func configureConstraint() {
        NSLayoutConstraint.activate([
            diaryListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            diaryListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
}
