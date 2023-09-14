//
//  Diary - DiaryViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
//  last modified by Mary & Whales

import UIKit
import OSLog

final class DiaryViewController: UIViewController {
    private let diaryManager: DiaryManager
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    init(diaryManager: DiaryManager = DiaryManager()) {
        self.diaryManager = diaryManager
        
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
        
        fetchDiaryContents()
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
        navigationItem.title = String(localized: "title")
    }
    
    @objc private func tappedAddDiaryButton() {
        let diaryContent = DiaryContent(title: "", body: "", timeInterval: Date().timeIntervalSince1970)
        
        showEditingDiaryViewController(with: diaryContent)
    }
    
    private func showEditingDiaryViewController(with diaryContent: DiaryContent) {
        let editingDiaryViewController = EditingDiaryViewController(with: diaryContent)
        
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
    
    private func fetchDiaryContents() {
        do {
            try diaryManager.fetchDiaryContents()
        } catch {
            os_log("%@", error.localizedDescription)
            presentAlertWith(title: String(localized: "failedFatchDataAlertTitle"),
                             message: String(localized: "failedFatchDataAlertMessage."),
                             preferredStyle: .alert,
                             actionConfigs: (String(localized: "failedFatchDataAlertAction"), .default, nil))
        }
    }
}

extension DiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryManager.diaryContents?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DiaryTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? DiaryTableViewCell
        else {
            return UITableViewCell()
        }
        
        guard let diaryContents = diaryManager.diaryContents,
              let diaryContent = diaryContents[safe: indexPath.row]
        else {
            return UITableViewCell()
        }
        
        cell.configureCell(data: diaryContent)
        
        return cell
    }
}

extension DiaryViewController: UITableViewDelegate, PresentableActivityView {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let diaryContents = diaryManager.diaryContents,
              let diaryContent = diaryContents[safe: indexPath.row]
        else {
            return
        }
        
        showEditingDiaryViewController(with: diaryContent)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let diaryContents = diaryManager.diaryContents,
              let diaryContent = diaryContents[safe: indexPath.row]
        else {
            return nil
        }
        
        let share = UIContextualAction(
            style: .normal,
            title: String(localized: "share")
        ) { (_, _, success: @escaping (Bool) -> Void) in
            
            let diaryContentItem = diaryContent.title + diaryContent.body
            
            self.presentActivityView(shareItem: diaryContentItem)
            success(true)
        }
        
        let delete = UIContextualAction(
            style: .destructive,
            title: String(localized: "delete")
        ) { (_, _, success: @escaping (Bool) -> Void) in
            
            self.presentCheckDeleteAlert { _ in
                ContainerManager.shared.delete(id: diaryContent.id)
                self.diaryManager.diaryContents?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            success(true)
        }
        
        return UISwipeActionsConfiguration(actions: [delete, share])
    }
}
