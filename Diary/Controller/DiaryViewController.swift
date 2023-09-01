//
//  Diary - DiaryViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryViewController: UIViewController {
    private var tableView: UITableView = UITableView()
    private var diaryList: [DiaryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        parseData()
    }
    
    private func parseData() {
        guard let dataAsset = NSDataAsset(name: "sample") else {
            presentAlert()
            return
        }
        
        do {
            diaryList = try JSONDecoder().decode([DiaryModel].self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func presentAlert() {
        let alert = UIAlertController(title: nil, message: "DataAsset를 찾지 못했습니다.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let diaryDetailViewController = DiaryDetailViewController(
            title: diaryList[index].title,
            body: diaryList[index].body,
            date: Date(timeIntervalSince1970: diaryList[index].date)
        )
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
}

extension DiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.basic) as? DiaryCell else {
            return UITableViewCell()
        }
        
        let index = indexPath.row
        let date = Date(timeIntervalSince1970: diaryList[index].date)
        let formattedDate = DateFormatter.diaryFormatter.string(from: date)
        
        cell.configureCell(
            title: diaryList[index].title,
            date: formattedDate,
            preview: diaryList[index].body
        )
        
        return cell
    }
}

private extension DiaryViewController {
    func configure() {
        configureRootView()
        configureNavigation()
        configureTableView()
        registerCell()
        configureSubviews()
        configureConstraints()
    }
    
    func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    func configureNavigation() {
        let action = UIAction { _ in
            let diaryDetailViewController = DiaryDetailViewController()
            self.navigationController?.pushViewController(diaryDetailViewController, animated: true)
        }
        
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: action)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func registerCell() {
        tableView.register(DiaryCell.self, forCellReuseIdentifier: CellIdentifier.basic)
    }
    
    func configureSubviews() {
        view.addSubview(tableView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
