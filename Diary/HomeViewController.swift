//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource {
    private let tableView = UITableView()
    private var diaryData: [Diary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        decodeSampleData()
        autoLayoutInit()
    }

    private func decodeSampleData() {
        guard let dataAsset = NSDataAsset(name: "sample") else {
            return
        }
        
        let decoder = JSONDecoder()
        
        do {
            diaryData = try decoder.decode([Diary].self, from: dataAsset.data)
            print(diaryData)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

extension HomeViewController {
    private func configureUI() {
        navigationItemInit()
        tableInit()
        autoLayoutInit()
    }
    
    private func navigationItemInit() {
        let rightItemButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: nil, action: nil)
        
        self.navigationItem.title = "일기장"
        self.navigationItem.rightBarButtonItem = rightItemButton
    }
    
    private func tableInit() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DiaryItemCell.self, forCellReuseIdentifier: DiaryItemCell.reuseIdentifier)
        
        self.view.addSubview(tableView)
    }
    
    private func autoLayoutInit() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}

