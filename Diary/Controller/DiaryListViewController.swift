//
//  Diary - DiaryListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    
    // MARK: - Private Property
    private let diaryStore: DiaryStorageProtocol
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    // MARK: - Life Cycle
    init(diaryStore: AssetDiaryStorage) {
        self.diaryStore = diaryStore
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIObject()
        configureUI()
        setupConstraints()
    }
}

// MARK: - Setup UI Object
extension DiaryListViewController {
    private func setupUIObject() {
        setupView()
        setupNavigationItem()
        setupTableView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationItem() {
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: nil)
        
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = plusButton
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
    }
}

// MARK: - TableView DataSource
extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryStore.diaryEntrys().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.identifier, for: indexPath) as? DiaryTableViewCell else {
            return UITableViewCell()
        }
        
        let diaryEntrys = diaryStore.diaryEntrys()
        let diaryEntry = diaryEntrys[indexPath.row]
        
        cell.setupContent(title: diaryEntry.title,
                          creationDate: String(diaryEntry.creationDate),
                          body: diaryEntry.body)
        
        return cell
    }
}

// MARK: - TableView Delegate
extension DiaryListViewController: UITableViewDelegate {
    
}

// MARK: - Configure UI
extension DiaryListViewController {
    private func configureUI() {
        configureView()
    }
    
    private func configureView() {
        view.addSubview(tableView)
    }
}

// MARK: - Setup Constraint
extension DiaryListViewController {
    private func setupConstraints() {
        setupTableViewConstraint()
    }
    
    private func setupTableViewConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
