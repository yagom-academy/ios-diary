//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class HomeViewController: UIViewController, UITableViewDataSource {
    private let tableView = UITableView()
    private let jsonDecoder = JsonDecoder()
    private var diaryData: [Diary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        diaryData = jsonDecoder.decodeSampleData()
        autoLayoutInit()
    }
    
    private func pushToDiaryDetailViewController(indexPath: Int?) {
        let diaryDetailViewController = DiaryDetailViewController()
        
        if let indexPath {
            diaryDetailViewController.forwardingDiaryData(diary: diaryData[indexPath])
        }
        
        self.navigationController?.pushViewController(
            diaryDetailViewController,
            animated: true
        )
    }
    
    @objc private func touchUpPlusButton() {
        pushToDiaryDetailViewController(indexPath: nil)
    }
}

extension HomeViewController {
    private func configureUI() {
        navigationItemInit()
        tableInit()
        autoLayoutInit()
    }
    
    private func navigationItemInit() {
        let rightItemButton = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(touchUpPlusButton)
        )
        
        self.navigationItem.title = "일기장"
        self.navigationItem.rightBarButtonItem = rightItemButton
    }
    
    private func tableInit() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            DiaryItemCell.self,
            forCellReuseIdentifier: DiaryItemCell.reuseIdentifier
        )
        
        self.view.addSubview(tableView)
    }
    
    private func autoLayoutInit() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryItemCell.reuseIdentifier) as? DiaryItemCell else {
            return UITableViewCell()
        }
        
        guard let diaryData = diaryData[safe: indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configure(with: diaryData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushToDiaryDetailViewController(indexPath: indexPath.row)
    }
}

