//
//  Diary - DiaryViewController.swift
//  Created by kaki, 레옹아범. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryViewController: UIViewController {
    private var tableView: UITableView = UITableView()
    private var diaryItems: [DiaryModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        
        configureTableView()
        configureNavigationController()
        parseSampleData()
    }
    
    private func parseSampleData() {
        guard let dataAsset = NSDataAsset(name: "sample") else { return }
        
        let decoder = JSONDecoder()
        
        do {
            diaryItems = try decoder.decode([DiaryModel].self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func pushDetailViewController(_ item: DiaryModel?) {
        let detailVC = DetailViewController(diaryItem: item)
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc private func plusButtonTapped() {
        pushDetailViewController(nil)
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
        guard let item = diaryItems[safe: indexPath.row] else { return }
        
        pushDetailViewController(item)
    }
}

// MARK: UI
extension DiaryViewController {
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
