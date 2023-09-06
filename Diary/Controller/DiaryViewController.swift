//
//  Diary - DiaryViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
//  last modified by Mary & Whales

import UIKit

final class DiaryViewController: UIViewController {
    private var diaryManager: DiaryManager
    
    private var tableView: UITableView = {
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

        configureView()
        configureTableView()
        setUpConstraints()
        
        fetchDiaryContents()
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
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func fetchDiaryContents() {
        do {
            try diaryManager.fetchDiaryContents(name: "sample")
        } catch {
            print(error.localizedDescription)
            presentAlertWith(title: "데이터 불러오기 실패", message: "앱을 다시 실행해주십시오.", actionConfigs: ("확인", .default, nil))
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

extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let diaryContents = diaryManager.diaryContents,
              let diaryContent = diaryContents[safe: indexPath.row]
        else {
            return
        }
        
        showEditingDiaryViewController(with: diaryContent)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
