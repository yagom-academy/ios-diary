//
//  Diary - DiaryViewController.swift
//  Created by kaki, 레옹아범. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryViewController: UIViewController {
    private let tableView: UITableView = UITableView()
    private var diaryItems: [Diary] = []
    private let manager = PersistenceManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchDiary()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func fetchDiary() {
        manager.fetchContent { [weak self] result in
            switch result {
            case .success(let diary):
                self?.diaryItems = diary
                self?.tableView.reloadData()
            case .failure(let error):
                self?.showFailAlert(error: error)
            }
        }
    }
    
    private func pushDiaryDetailViewController(with diary: Diary? = nil, _ state: DiaryState) {
        let detailVC = DiaryDetailViewController(diaryItem: diary, state: state)
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func deleteTableViewItem(item: Diary, indexPath: IndexPath) {
        manager.deleteContent(at: item) { [weak self] result in
            switch result {
            case .success():
                self?.tableView.performBatchUpdates({
                    self?.diaryItems.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                })
            case .failure(let error):
                self?.showFailAlert(error: error)
            }
        }
    }
    
    @objc private func plusButtonTapped() {
        pushDiaryDetailViewController(.create)
    }
}

extension DiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryInfoTableViewCell.identifier) as? DiaryInfoTableViewCell,
              let sampleDiaryItem = diaryItems[safe: indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configureLabel(item: sampleDiaryItem)
        
        return cell
    }
}

extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let diary = diaryItems[safe: indexPath.row] else { return }
        
        pushDiaryDetailViewController(with: diary, .edit)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let diary = self.diaryItems[safe: indexPath.row] else { return nil }
        
        let deleteContextualAction = UIContextualAction(
            style: .destructive,
            title: nil) { [weak self] _, _, completionHandler in
                self?.deleteTableViewItem(item: diary, indexPath: indexPath)
                completionHandler(true)
            }
        
        deleteContextualAction.image = UIImage(systemName: "trash.fill")?.withTintColor(.white)
        deleteContextualAction.backgroundColor = .systemRed
        
        let shareContextualAction = UIContextualAction(
            style: .normal,
            title: nil) { [weak self] _, _, completionHandler in                
                self?.showActivityView(diary.content)
                completionHandler(true)
            }
        
        shareContextualAction.image = UIImage(systemName: "square.and.arrow.up")
        shareContextualAction.backgroundColor = .systemBlue
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteContextualAction, shareContextualAction])
        
        return configuration
    }
}

// MARK: UI
extension DiaryViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureTableView()
        configureNavigationController()
    }
    
    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DiaryInfoTableViewCell.self, forCellReuseIdentifier: DiaryInfoTableViewCell.identifier)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureNavigationController() {
        self.navigationItem.title = "일기장"
        let rightItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        navigationItem.rightBarButtonItem = rightItem
    }
}
