//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryViewController: UIViewController {
    private var sampleData: [SampleData] = []
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
       return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableViewAttribute()
        configureTableViewConstraint()
        getSampleData()
    }
    
    private func configureTableViewConstraint() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func tableViewAttribute() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DiaryTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "diaryTableViewCell")
    }
    
    private func getSampleData() {
        let asset = NSDataAsset(name: "sample")
        guard let data = asset?.data else { return }
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            sampleData = try jsonDecoder.decode([SampleData].self, from: data)
            print(sampleData)
        } catch {
            print(error)
        }
    }
}

// MARK: - TableView Delegate
extension DiaryViewController: UITableViewDelegate { }

// MARK: - TableView DataSource
extension DiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diaryTableViewCell",
                                                 for: indexPath) as? DiaryTableViewCell ?? DiaryTableViewCell()
        return cell
    }
}
