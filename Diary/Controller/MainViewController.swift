//
//  MainViewController.swift
//  Diary
//
//  Created by Kiwi, Brad on 2022/08/16.
//

import UIKit

class MainViewController: UIViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    private let diaryItemTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setNavigationbar()
        self.configureTableView()
    }
    
    private func setNavigationbar() {
        self.navigationController?.navigationBar.topItem?.title = "일기장"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didAddDiaryButtonTapped))
    }
    
    @objc func didAddDiaryButtonTapped() {
    }
    
    private func configureTableView() {
        self.diaryItemTableView.dataSource = self
        self.diaryItemTableView.delegate = self
        self.diaryItemTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(diaryItemTableView)
        
        NSLayoutConstraint.activate([
            self.diaryItemTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.diaryItemTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.diaryItemTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.diaryItemTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        cell.diaryTitle.text = "Title"
        cell.diaryBody.text = "Body"
        cell.diaryDate.text = "Data"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
