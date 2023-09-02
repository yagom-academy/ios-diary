//
//  Diary - DiaryViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
//  last modified by Mary & Whales

import UIKit

final class DiaryViewController: UIViewController {
    private let diaryManager = DiaryManager()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureTableView()
        setUpConstraints()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        configureNavigationItem()
    }
    
    private func configureNavigationItem() {
        let addDiaryBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                    target: self,
                                                    action: #selector(tappedAddDiaryButton))
        
        navigationItem.rightBarButtonItem = addDiaryBarButtonItem
        navigationItem.title = String(localized: "title")
    }
    
    @objc private func tappedAddDiaryButton() {
        let today = DiaryDateFormatter().format(from: Date())
        let diaryContent = DiaryContent(title: "", body: "", date: today)
        
        showEditingDiaryViewController(with: diaryContent)
    }
    
    private func showEditingDiaryViewController(with diaryContent: DiaryContent) {
        let editingDiaryViewController = EditingDiaryViewController(with: diaryContent)
        
        show(editingDiaryViewController, sender: self)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
    }
    
    private func setUpConstraints() {
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
        return diaryManager.diaryContents?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.identifier, for: indexPath)
                as? DiaryTableViewCell
        else {
            return UITableViewCell()
        }
        
        guard let diaryContents = diaryManager.diaryContents else {
            return UITableViewCell()
        }
        
        cell.configureCell(data: diaryContents[indexPath.row])

        return cell
    }
}

extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let diaryContents = diaryManager.diaryContents else { return }
        
        showEditingDiaryViewController(with: diaryContents[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
