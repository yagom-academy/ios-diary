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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        decodeContents()
        tableView.reloadData()
    }
    
    private func configureUIOption() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(moveToAppendDiary))
    }
    
    private func decodeContents() {
        contentsList = CoreDataManager.shared.read()
        if contentsList?.isEmpty == false { return }
        
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
        
        cell.configure(title: contents.title, description: contents.body, date: contents.localizedDate)
        
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
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let contents = contentsList?[indexPath.row] else { return nil }
        
        let share = UIContextualAction(style: .normal, title: "Share") { _, _, _ in
            let activityViewController = UIActivityViewController(activityItems: [contents.title],
                                                                  applicationActivities: nil)
            
            self.present(activityViewController, animated: true)
        }
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            guard let identifier = contents.identifier else { return }
            self?.showDeleteAlert(identifier: identifier, indexPath: indexPath)
        }
        
        share.backgroundColor = .systemGreen
        
        return UISwipeActionsConfiguration(actions: [share, delete])
    }
    
    private func showDeleteAlert(identifier: UUID, indexPath: IndexPath) {
        AlertManager().showDeleteAlert(target: self) { [weak self] in
            CoreDataManager.shared.delete(id: identifier)
            self?.contentsList?.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
