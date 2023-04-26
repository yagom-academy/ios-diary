//
//  Diary - DiaryViewController.swift
//  Created by SeHong.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class DiaryViewController: UIViewController {

    private let navigationTitle = "일기장"
    private let plusIcon = "plus"
    
    private var diaryListTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(DiaryTableViewCell.self,
                           forCellReuseIdentifier: DiaryTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private var diaryItems = [Diary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        setupLayout()
        fetchJSONData()
    }

    private func setupTableView() {
        diaryListTableView.dataSource = self
        diaryListTableView.delegate = self
    }
    
    private func setupNavigationBar() {
        title = navigationTitle
        let addButton = UIBarButtonItem(
            image: UIImage(systemName: plusIcon),
            style: .plain,
            target: self,
            action: #selector(createDiaryButtonTapped)
          )
          navigationItem.setRightBarButton(addButton, animated: false)
        
    }
    
    @objc func createDiaryButtonTapped() {
        let createDiaryViewController = DiaryDetailViewController(diaryItem: .new)
        navigationController?.pushViewController(createDiaryViewController, animated: true)
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(diaryListTableView)
        
        NSLayoutConstraint.activate([
            diaryListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            diaryListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            diaryListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            diaryListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func fetchJSONData() {
        guard let data = JsonConverter.decode() else { return }
        diaryItems = data
    }
    
}

extension DiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return diaryItems.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DiaryTableViewCell.identifier,
            for: indexPath) as? DiaryTableViewCell else { return UITableViewCell() }
        cell.accessoryType = .disclosureIndicator

        if let diaryItem = diaryItems[safe: indexPath.row] {
            cell.configureCellData(diaryItem: diaryItem)
        }
        
        return cell
    }

}

extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailViewController = DiaryDetailViewController(diaryItem: diaryItems[indexPath.row])
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
