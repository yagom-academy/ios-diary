//
//  Diary - DiaryListViewController.swift
//  Created by Rowan, Harry. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class DiaryListViewController: UIViewController {
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRootView()
        configureTableView()
    }

    private func configureRootView() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension DiaryListViewController: UITableViewDelegate {

}
