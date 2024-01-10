//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    //MARK: - Property
    private let dataManager = SampleDataManager()
    private var todayDate = Date.generateTodayDate()
    private var diaryData: [DiaryData] = []
    private let coreDataManager = CoreDataManager.shared
    
    private let tableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupTableViewConstraints()
        readDiaryData()
//        setupDatas()
    }
    
    //MARK: - Helper
    private func readDiaryData() {
        diaryData = coreDataManager.readDiaryData()
        tableView.reloadData()
    }
    
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
        coreDataManager.createDiaryData(date: todayDate)
        
        diaryContentsViewController.diaryData = coreDataManager.readDiaryData().last
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
//        guard let data = dataManager.generateDiaryData(asset: "sample", type: [DiarySampleData].self) else { return }
//        diaryData = data
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryListCell.identifier, for: indexPath) as? DiaryListCell else { return UITableViewCell() }
        
        cell.injectData(title: diaryData[indexPath.row].title, date: todayDate, preview: diaryData[indexPath.row].body)
        cell.injectAccessoryType(to: .disclosureIndicator)
        
        return cell
    }
}

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diaryContentsViewController = DiaryContentsViewController()
        // 다음 스텝에서 날짜를 생성해서 넣어줄 수 있도록 수정하겠습니다.
        diaryContentsViewController.diaryData = self.diaryData[indexPath.row]
//        diaryContentsViewController.injectData(title: diaryData[indexPath.row].title, body: diaryData[indexPath.row].body, date: diaryData[indexPath.row].date)
        
        navigationController?.pushViewController(diaryContentsViewController, animated: true)
    }
}
