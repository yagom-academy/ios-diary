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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
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
        } catch {
            print(error)
        }
    }
}

// MARK: - TableView Delegate
extension DiaryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailView: DetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailView") as? DetailViewController else { return }
        detailView.delegate = self
        detailView.diaryData = sampleData[indexPath.row]
        detailView.indexPath = indexPath
        self.navigationController?.pushViewController(detailView, animated: true)
        
    }
}

// MARK: - TableView DataSource
extension DiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sampleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diaryTableViewCell",
                                                 for: indexPath) as? DiaryTableViewCell ?? DiaryTableViewCell()
        cell.configureCell(title: sampleData[indexPath.row].title,
                           createdAt: sampleData[indexPath.row].createdAt,
                           body: sampleData[indexPath.row].body)
        
        return cell
    }
}

extension DiaryViewController: DetailViewControllerDelegate {
    
    func sendData(title: String, body: String, indexPath: IndexPath) {
        sampleData[indexPath.row].title = title
        sampleData[indexPath.row].body = body
        
    }
}
