//
//  Diary - DiaryListViewController.swift
//  Created by Hugh, Derrick on 2022/08/16.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    private enum Section {
        case main
    }
    
    private let jsonManager = JSONManager()
    
    private var dataSource: UITableViewDiffableDataSource<Section, DiaryContent>?
    
    private let diaryListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefault()
        configureLayout()
        fetchData()
        configureDataSource()
    }
    
    private func setupDefault() {
        self.view.backgroundColor = .white
        self.view.addSubview(diaryListTableView)
        
        self.title = "일기장"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTappedAddButton))
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, DiaryContent>(tableView: diaryListTableView,
                                                                          cellProvider: { tableView, indexPath, content -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DiaryTableViewCell else {
                return UITableViewCell()
            }

            cell.configureUI(data: content)
            return cell
        })
    }
    
    private func fetchData() {
        let result = jsonManager.checkFileAndDecode(dataType: [DiaryContent].self, "diarySample")
        switch result {
        case .success(let contents):
            updateDataSource(data: contents)
        default:
            return
        }
    }
    
    private func updateDataSource(data: [DiaryContent]) {
            var snapshot = NSDiffableDataSourceSnapshot<Section, DiaryContent>()
            snapshot.appendSections([.main])
            snapshot.appendItems(data)

            dataSource?.apply(snapshot)
        }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            diaryListTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            diaryListTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            diaryListTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            diaryListTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func didTappedAddButton() {
        let addDiaryViewController = AddDiaryViewController()
        
        self.navigationController?.pushViewController(addDiaryViewController, animated: true)
    }
}
