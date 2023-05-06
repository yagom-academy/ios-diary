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
    private let alertMaker: DiaryAlertFactoryService = DiaryAlertMaker()
    private let alertDataMaker: DiaryAlertDataService = DiaryAlertDataMaker()
    private let dataManager = DiaryDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpRootView()
        setUpNavigationBar()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchDiaryList()
        tableView.reloadData()
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
        let result = dataManager.readAllDAO()
        let mappedList = result.map { Diary(diaryDAO: $0) }
        
        self.diaryList = mappedList
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
        
        cell.configureLabels(with: diary)
        
        return cell
    }
}

// MARK: - TableViewDelegate
extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diary = diaryList[indexPath.row]
        let diaryContentViewController = DiaryContentViewController(diary: diary)
        
        navigationController?.pushViewController(diaryContentViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let share = makeContextualAction(style: .normal,
                                         imageName: "square.and.arrow.up",
                                         color: .systemIndigo) { [weak self] in
            guard let self else { return }
            
            self.presentActivityView(indexPath: indexPath)
        }
        
        let delete = makeContextualAction(style: .destructive,
                                          imageName: "trash",
                                          color: .systemRed) { [weak self] in
            guard let self else { return }
            
            self.presentDeleteAlert(indexPath: indexPath)
        }
        
        return UISwipeActionsConfiguration(actions: [delete, share])
    }
    
    private func makeContextualAction(
        style: UIContextualAction.Style,
        imageName: String,
        color: UIColor,
        completion: @escaping () -> Void
    ) -> UIContextualAction {
        let contextualAction = UIContextualAction(style: style,
                                                  title: nil) { _, _, handler in
            completion()
            handler(true)
        }
        
        contextualAction.image = UIImage(systemName: imageName)
        contextualAction.backgroundColor = color
        
        return contextualAction
    }
}

// MARK: - Present View
extension DiaryListViewController {
    private func presentDeleteAlert(indexPath: IndexPath) {
        let alertData = alertDataMaker.deleteAlertData { [weak self] in
            guard let self else { return }
            
            let id = self.diaryList[indexPath.row].id
            
            self.dataManager.deleteDAO(id: id)
            self.diaryList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let alert = alertMaker.deleteDiaryAlert(for: alertData)
        
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
