//
//  Diary - DiaryListViewController.swift
//  Created by Rowan, Harry. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    private let tableView = UITableView()
    private var diaryList: [Diary] = []
    private let sampleDecoder = DiaryDecodeManager()
    private let alertFactory: DiaryAlertFactoryService = DiaryAlertMaker()
    private let alertDataMaker: DiaryAlertDataService = DiaryAlertDataMaker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpRootView()
        setUpNavigationBar()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchDiaryList()
    }

    private func setUpRootView() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
    }
    
    private func setUpNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDiary))
        
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc
    private func addDiary() {
        let nextViewController = DiaryContentViewController()
        
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DiaryListCell.self,
                           forCellReuseIdentifier: DiaryListCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        setUpTableViewLayout()
    }
    
    private func setUpTableViewLayout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safe.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
    }
    
    private func fetchDiaryList() {
        let result = DiaryCoreDataManager.shared.fetchDiary()
        
        switch result {
        case .success(let diaryList):
            self.diaryList = diaryList
            self.tableView.reloadData()
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}

// MARK: - TableViewDataSource
extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: DiaryListCell.identifier,
                                 for: indexPath) as? DiaryListCell
        else { return UITableViewCell() }
        
        let diary = diaryList[indexPath.row]
        let date = Date(timeIntervalSince1970: diary.date)
        let formattedDate = DateFormatter.diaryForm.string(from: date)
        
        cell.configureLabels(title: diary.title, date: formattedDate, body: diary.body)
        
        return cell
    }
}

// MARK: - TableViewDelegate
extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diary = diaryList[indexPath.row]
        let nextViewController = DiaryContentViewController(diary: diary)
        
        navigationController?.pushViewController(nextViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let share = UIContextualAction(style: .normal,
                                       title: nil) { [weak self] _, _, completion in
            guard let self else { return }
            
            self.presentActivityView(indexPath: indexPath)
            completion(true)
        }
        share.image = UIImage(systemName: "square.and.arrow.up")
        share.backgroundColor = .systemGreen
        
        let delete = UIContextualAction(style: .destructive,
                                        title: nil) { [weak self] _, _, completion in
            guard let self else { return }
            
            self.presentDeleteAlert(indexPath: indexPath)
            completion(true)
        }
        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete, share])
    }
}

// MARK: - Present View
extension DiaryListViewController {
    private func presentDeleteAlert(indexPath: IndexPath) {
        let alertData = alertDataMaker.deleteAlertData { [weak self] in
            guard let self, let id = self.diaryList[indexPath.row].id else { return }
            
            DiaryCoreDataManager.shared.deleteDiary(id: id)
            self.diaryList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let alert = alertFactory.deleteDiaryAlert(for: alertData)
        
        present(alert, animated: true)
    }
    
    private func presentActivityView(indexPath: IndexPath) {
        let diary = diaryList[indexPath.row]
        let title = diary.title ?? ""
        let body = diary.body ?? ""
        let text = title + body
        let activityView = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        self.present(activityView, animated: true)
    }
}
