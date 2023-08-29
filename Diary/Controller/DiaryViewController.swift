//
//  Diary - DiaryViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryViewController: UIViewController {
    private var tableView: UITableView = UITableView()
    private var diaryModel: [DiaryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        parseData()
    }
    
    private func parseData() {
        guard let dataAsset = NSDataAsset(name: "sample") else {
            return
        }
                
        do {
            diaryModel = try JSONDecoder().decode([DiaryModel].self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension DiaryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }

        return cell
    }
}

private extension DiaryViewController {
    func configure() {
        configureRootView()
        configureNavigation()
        configureTableView()
        configureCell()
        configureSubviews()
        configureConstraints()
    }
    
    func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    func configureNavigation() {
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureCell() {
        tableView.register(DiaryCell.self, forCellReuseIdentifier: "cell")
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
