//
//  Diary - DiaryListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    // MARK: - Property
    private let coreDataManager: CoreDataManager
    private var diaryList: [DiaryEntity] = []
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    // MARK: - Initializer
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDiary()
        configureNavigation()
        configureBackgroundColor()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadDiary()
    }
    
    // MARK: - Configure view
    private func configureNavigation() {
        navigationItem.title = String(localized: "DiaryListNavigationTitle")
        
        let action = UIAction { [weak self] _ in
            guard let self else {
                return
            }
            
            self.pushDiaryViewController()
        }
        let barButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: action)
        
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func configureBackgroundColor() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        configureTableViewConstraint()
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configureTableViewConstraint() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: Method
    private func pushDiaryViewController(indexPath: IndexPath? = nil) {
        let diaryViewController = DiaryViewController(coreDataManager: coreDataManager)
        
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    private func loadDiary() {
        do {
            diaryList = try coreDataManager.fetch(of: DiaryEntity())
            tableView.reloadData()
        } catch {
            presentErrorCheckAlert(error: error)
        }
    }
    
    private func deleteDiaryRow(at indexPath: IndexPath) {
        self.diaryList.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - UITableViewDataSource
extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DiaryTableViewCell.identifier,
            for: indexPath
        ) as? DiaryTableViewCell else {
            return UITableViewCell()
        }
        
        let diary = diaryList[indexPath.row]
        
        cell.configureContents(diary: diary)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DiaryListViewController: UITableViewDelegate, DiaryShareable, DiaryAlertPresentable {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let diary = diaryList[indexPath.row]
        let diaryViewController = DiaryViewController(coreDataManager: coreDataManager, diary: diary)
        
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let diary = diaryList[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completionHandler in
            guard let self else {
                return
            }
            
            self.presentDeleteConfirmAlert {
                do {
                    self.coreDataManager.deleteContext(of: diary)
                    try self.coreDataManager.saveContext()
                    self.deleteDiaryRow(at: indexPath)
                } catch {
                    self.presentDiarySaveFailureAlert()
                }
            }
            
            completionHandler(true)
        }
        let shareAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completionHandler in
            guard let self else {
                return
            }
            
            self.shareDiary(data: diary)
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        shareAction.backgroundColor = .systemGray
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
        return configuration
    }
}
