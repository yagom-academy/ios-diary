//
//  Diary - DiaryViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
//  last modified by Mary & Whales

import UIKit

final class DiaryViewController: UIViewController {
    private let diaryManager: DiaryEditable
    private let logger: Logger
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    init(diaryManager: DiaryEditable, logger: Logger = Logger()) {
        self.diaryManager = diaryManager
        self.logger = logger
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshDiaries()
        tableView.reloadData()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        configureNavigationItem()
        setupConstraints()
    }
    
    private func configureNavigationItem() {
        let addDiaryBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                    target: self,
                                                    action: #selector(tappedAddDiaryButton))
        
        navigationItem.rightBarButtonItem = addDiaryBarButtonItem
        navigationItem.title = "title".localized
    }
    
    @objc private func tappedAddDiaryButton() {
        let diaryContent = DiaryContent(title: "", body: "", timeInterval: Date().timeIntervalSince1970)
        
        showEditingDiaryViewController(with: diaryContent)
    }
    
    private func showEditingDiaryViewController(with diaryContent: DiaryContent) {
        let editingDiaryViewController = EditingDiaryViewController(diaryManager: diaryManager,
                                                                    logger: logger,
                                                                    with: diaryContent)
        
        show(editingDiaryViewController, sender: self)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.reuseIdentifier)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

extension DiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryManager.diaryContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DiaryTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? DiaryTableViewCell
        else {
            return UITableViewCell()
        }
        
        guard let diaryContent = diaryManager.diaryContents[safe: indexPath.row]
        else {
            return UITableViewCell()
        }
        
        cell.configureCell(data: diaryContent)
        
        return cell
    }
}

extension DiaryViewController: UITableViewDelegate, ActivityViewPresentable {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let diaryContent = diaryManager.diaryContents[safe: indexPath.row]
        else {
            return
        }
        
        showEditingDiaryViewController(with: diaryContent)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let diaryContent = diaryManager.diaryContents[safe: indexPath.row]
        else {
            return nil
        }
        
        let share = UIContextualAction(
            style: .normal,
            title: "share".localized
        ) { (_, _, success: @escaping (Bool) -> Void) in
            
            let diaryContentItem = diaryContent.title + diaryContent.body
            
            self.presentActivityView(shareItem: diaryContentItem)
            success(true)
        }
        
        let delete = UIContextualAction(
            style: .destructive,
            title: "delete".localized
        ) { (_, _, success: @escaping (Bool) -> Void) in
            
            self.presentCheckDeleteAlert { [self] _ in
                deleteDiary(id: diaryContent.id)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            success(true)
        }
        
        return UISwipeActionsConfiguration(actions: [delete, share])
    }
}

extension DiaryViewController {
    private func refreshDiaries() {
        do {
            try diaryManager.refresh()
        } catch {
            logger.osLog(error.localizedDescription)
            presentAlert(title: "failedFetchDataAlertTitle".localized,
                         message: "failedFetchDataAlertMessage".localized,
                         preferredStyle: .alert,
                         actionConfigs: ("failedFetchDataAlertAction".localized, .default, nil))
        }
    }
    
    private func deleteDiary(id: UUID) {
        do {
            try diaryManager.delete(id: id)
        } catch {
            logger.osLog(error.localizedDescription)
            presentAlert(title: "failedDeleteDataAlertTitle".localized,
                         message: "failedDeleteDataAlertMessage".localized,
                         preferredStyle: .alert,
                         actionConfigs: ("failedDeleteDataAlertAction".localized, .default, nil))
        }
    }
}
