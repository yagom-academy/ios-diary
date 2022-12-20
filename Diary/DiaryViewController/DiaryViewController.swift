//
//  Diary - DiaryViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryViewController: UIViewController {
    private let containerView: ContainerView = ContainerView()

    override func loadView() {
        super.loadView()
        self.view = containerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureTableView()
        configureNavigationBar()
    }
    
    private func configureTableView() {
        containerView.tableView.register(DiaryListCell.self, forCellReuseIdentifier: DiaryListCell.identifier)
        containerView.tableView.delegate = self
        containerView.tableView.dataSource = self
    }

    private func configureNavigationBar() {
        self.navigationItem.title = "일기장"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add)
        self.navigationItem.rightBarButtonItem?.target = self
        self.navigationItem.rightBarButtonItem?.action = #selector(tappedAddButton)
    }

    @objc private func tappedAddButton(_ sender: UIBarButtonItem) {
        print(#function)
    }
}

extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryListCell.identifier) as? DiaryListCell
        else {
            return UITableViewCell()
        }
        
        return cell
    }
}
