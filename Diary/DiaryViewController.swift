//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class DiaryViewController: UIViewController {
    
    var diaries: [Diary]?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationItem()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DiaryCell.self, forCellReuseIdentifier: DiaryCell.identifier)
        guard let assetData = NSDataAsset.init(name: "sample") else {
            return
        }
        guard let diaries = try? JSONDecoder().decode([Diary].self, from: assetData.data) else {
            return
        }
        self.diaries = diaries
        tableView.reloadData()
    }
    
    func configureUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func configureNavigationItem() {
        self.navigationItem.title = "일기장"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDiaryPage))
        
    }
    
    @objc func addDiaryPage() { }
    
}

extension DiaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryCell.identifier) as? DiaryCell else { return UITableViewCell() }
        let diary = diaries?[indexPath.row]
        cell.configureData(title: diary?.title, date: Date(timeIntervalSince1970: diary!.createdAt).description, content: diary?.body)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
