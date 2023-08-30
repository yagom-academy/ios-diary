//
//  Diary - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//  Last modified by Maxhyunm, Hamg.

import UIKit

final class DiaryListViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    private var diaryEntities = [DiaryEntity]()
    private let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        configureUI()
        setupTableView()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        self.title = "일기장"
        
        let addDiary = UIAction(image: UIImage(systemName: "plus")) { [weak self] _ in
            guard let self else { return }
            let createDiaryView = CreateDiaryViewController()
            self.navigationController?.pushViewController(createDiaryView, animated: true)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(primaryAction: addDiary)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DiaryListTableViewCell.self, forCellReuseIdentifier: DiaryListTableViewCell.identifier)
    }
    
    private func setupData() {
        guard let loadDiaryEntity: [DiaryEntity] = DecodingManager.decodeJson(from: "sample") else { return }
        
        diaryEntities = loadDiaryEntity
    }
}

extension DiaryListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        diaryEntities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryListTableViewCell.identifier,
                                                       for: indexPath) as?
                DiaryListTableViewCell else { return UITableViewCell() }
        
        let diaryEntity = diaryEntities[indexPath.row]
        let date = dateFormatter.formatToString(from: diaryEntity.createdAt, with: "YYYY년 MM월 dd일")
        
        cell.setModel(title: diaryEntity.title, date: date, body: diaryEntity.body)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
