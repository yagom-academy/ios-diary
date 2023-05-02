//
//  Diary - DiaryViewController.swift
//  Created by kaki, 레옹아범. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryViewController: UIViewController {
    private let tableView: UITableView = UITableView()
    private var diaryItems: [Diary] = []
    private let manager = PersistenceManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            diaryItems = try manager.fetchContent()
            tableView.reloadData()
        } catch {
            showFailAlert(error: error)
        }
    }
    
    private func pushDiaryDetailViewController(with diary: Diary? = nil, _ state: DiaryState) {
        let detailVC = DiaryDetailViewController(diaryItem: diary, state: state)
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc private func plusButtonTapped() {
        pushDiaryDetailViewController(.create)
    }
}

extension DiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryInfoTableViewCell.identifier) as? DiaryInfoTableViewCell,
              let sampleDiaryItem = diaryItems[safe: indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configureLabel(item: sampleDiaryItem)
        
        return cell
    }
}

extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let diary = diaryItems[safe: indexPath.row] else { return }
        
        pushDiaryDetailViewController(with: diary, .edit)
    }
}

// MARK: UI
extension DiaryViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureTableView()
        configureNavigationController()
    }
    
    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DiaryInfoTableViewCell.self, forCellReuseIdentifier: DiaryInfoTableViewCell.identifier)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureNavigationController() {
        self.navigationItem.title = "일기장"
        let rightItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        navigationItem.rightBarButtonItem = rightItem
    }
}
