//
//  MainViewController.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/08/16.
//

import UIKit

final class MainViewController: UIViewController {
    
    let diaryManager = DiaryManager(dbManager: StubDBManager())
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    private let diaryItemTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setNavigationbar()
        self.configureTableView()
        self.registerDiaryNotification()
        self.diaryManager.loadData()
    }
    
    private func setNavigationbar() {
        self.navigationItem.title = "일기장"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didAddDiaryButtonTapped))
    }
    
    @objc private func didAddDiaryButtonTapped() {
        navigationController?.pushViewController(DiaryViewController(), animated: true)
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
    
    private func registerDiaryNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTableView),
                                               name: .diaryModelDataDidChanged,
                                               object: nil)
    }
    
    @objc private func updateTableView() {
        self.diaryItemTableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryManager.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: diaryManager.content(index: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diaryDetailViewController = DiaryDetailViewController()
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
        diaryDetailViewController.loadData(data: diaryManager.content(index: indexPath.row))
    }
    
}
