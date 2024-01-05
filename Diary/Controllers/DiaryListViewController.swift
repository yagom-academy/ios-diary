//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    //MARK: - Property
    private let tableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var diaryData: [DiaryData] = []
    private let dataManager = SampleDataManager()
    private var todayDate = Date.generateTodayDate()
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewDiary))
        navigationController?.navigationBar.standardAppearance = apearance
        navigationController?.navigationBar.compactAppearance = apearance
        navigationController?.navigationBar.scrollEdgeAppearance = apearance
    }
    
    @objc private func addNewDiary() {
        let diaryContentsViewController = DiaryContentsViewController()
        diaryContentsViewController.dateTitle = todayDate
        
        navigationController?.pushViewController(diaryContentsViewController, animated: true)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DiaryListCell.self, forCellReuseIdentifier: DiaryListCell.identifier)
    }
    
    private func setupTableViewConstraints() {
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
        cell.dateLabel.text = todayDate
        cell.previewLabel.text = diaryData[indexPath.row].body
        
        return cell
    }
}

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diaryContentsViewController = DiaryContentsViewController()
        // 다음 스텝에서 날짜를 생성해서 넣어줄 수 있도록 수정하겠습니다.
        diaryContentsViewController.dateTitle = "2024년 1월 3일"
        diaryContentsViewController.body = diaryData[indexPath.row].body
        diaryContentsViewController.diaryTitle = diaryData[indexPath.row].title
        
        navigationController?.pushViewController(diaryContentsViewController, animated: true)
    }
}
