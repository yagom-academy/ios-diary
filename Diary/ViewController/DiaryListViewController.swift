//
//  Diary - DiaryListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    private var diaryList: [Diary] = []
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDiary()
        configureNavigation()
        configureBackgroundColor()
        configureTableView()
    }
    
    private func loadDiary() {
        do {
            guard let asset = NSDataAsset(name: "sample") else {
                throw DataLoadError.assetNotFound
            }
            
            let decoder = JSONDecoder()
            
            guard let data = try? decoder.decode([Diary].self, from: asset.data) else {
                throw DataLoadError.decodeFailure
            }
            
            diaryList = data
        } catch DataLoadError.assetNotFound {
            print("asset을 찾을 수 없습니다.")
        } catch DataLoadError.decodeFailure {
            print("decode에 실패했습니다.")
        } catch {
            print("알 수 없는 에러가 발생했습니다.")
        }
    }
    
    private func configureNavigation() {
        navigationItem.title = "일기장"
        
        let action = UIAction { _ in
            self.addDiary()
        }
        let barButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: action)
        
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func addDiary() {
        let diaryViewController = DiaryViewController()
        
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    private func configureBackgroundColor() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        configureTableViewConstraint()
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configureTableViewConstraint() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DiaryTableViewCell.identifier,
            for: indexPath
        ) as? DiaryTableViewCell else {
            return UITableViewCell()
        }
        let diary = diaryList[indexPath.row]
        cell.configureContents(diary: diary)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let diary = diaryList[indexPath.row]
        let diaryViewController = DiaryViewController(diary: diary)
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
}
