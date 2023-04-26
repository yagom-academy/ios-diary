//
//  DiaryListViewController.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/04/24.
//

import UIKit

final class DiaryListViewController: UIViewController {
    private let tableView = UITableView()
    private var contentsList: [Contents]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIOption()
        decodeContents()
        configureTableView()
    }
    
    private func configureUIOption() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(moveToAppendDiary))
    }
    
    private func decodeContents() {
        let assetName = "sample"
        let result = DecodeManager().decodeJsonAsset(name: assetName, type: [Contents].self)
        
        switch result {
        case .success(let data):
            contentsList = data
        case .failure(let error):
            let alertManager = AlertManager()
            alertManager.showErrorAlert(target: self, error: error)
        }
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.register(ContentsTableViewCell.self, forCellReuseIdentifier: ContentsTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func moveToAppendDiary() {
        let diaryDetailViewController = DiaryDetailViewController(contents: nil)
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
}

// MARK: - Table view data source
extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentsList?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ContentsTableViewCell.identifier,
            for: indexPath) as? ContentsTableViewCell else {
            return UITableViewCell()
        }
        
        guard let contents = contentsList?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configure(title: contents.title, description: contents.description, date: contents.localizedDate)
        
        return cell
    }
}

// MARK: - Table view delegate
extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let contents = contentsList?[indexPath.row] else { return }
        
        let diaryDetailViewController = DiaryDetailViewController(contents: contents)
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
