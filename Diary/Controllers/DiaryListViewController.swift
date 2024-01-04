//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    //MARK: - property
    private let tableView = UITableView()
    private var diaryData: [DiaryData] = []
    private let dataManager = SampleDataManager()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupTableViewConstraints()
        setupDatas()
    }
    
    //MARK: - Helper
    private func setupNavigationBar() {
        let apearance = UINavigationBarAppearance()
        apearance.configureWithOpaqueBackground()
        apearance.backgroundColor = .white
        
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDiary))
        navigationController?.navigationBar.standardAppearance = apearance
        navigationController?.navigationBar.compactAppearance = apearance
        navigationController?.navigationBar.scrollEdgeAppearance = apearance
    }
    
    @objc private func addDiary() {
        navigationController?.pushViewController(DiaryContentsViewController(), animated: true)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DiaryListCell.self, forCellReuseIdentifier: DiaryListCell.identifier)
    }
    
    private func setupTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func setupDatas() {
        guard let data = dataManager.getDiaryData() else { return }
        diaryData = data
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryListCell.identifier, for: indexPath) as? DiaryListCell else { return UITableViewCell() }
        
        cell.accessoryType = .disclosureIndicator
        cell.titleLabel.text = diaryData[indexPath.row].title
        cell.dateLabel.text = "2024년 1월 3일"
        cell.previewLabel.text = diaryData[indexPath.row].body
        
        return cell
    }
}

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diaryContentsViewController = DiaryContentsViewController()
        diaryContentsViewController.dateTitle = "2024년 1월 3일"
        diaryContentsViewController.body = diaryData[indexPath.row].body
        diaryContentsViewController.diaryTitle = diaryData[indexPath.row].title
        
        navigationController?.pushViewController(diaryContentsViewController, animated: true)
    }
}
