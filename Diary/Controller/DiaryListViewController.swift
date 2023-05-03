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
    private let alertFactory: AlertFactoryService = AlertMaker()
    private let alertDataMaker: AlertDataService = AlertViewDataMaker()
    
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
        let result = DiaryCoreDataManager.shared.fetchDiary()
        
        switch result {
        case .success(let diaryList):
            self.diaryList = diaryList
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}

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
        let share = UIContextualAction(style: .normal, title: nil) {
            [weak self] _, _, completion in
//            self.showActivityView()
            completion(true)
        }
        share.image = UIImage(systemName: "square.and.arrow.up")
        share.backgroundColor = .systemGreen
        
        let delete = UIContextualAction(style: .destructive, title: nil) {
            [weak self] _, _, completion in
            self?.presentDeleteAlert(indexPath: indexPath)
            completion(true)
        }
        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete, share])
    }
}

// MARK: - Alert
extension DiaryListViewController {
    private func presentDeleteAlert(indexPath: IndexPath) {
        let delete = AlertActionData(actionTitle: "삭제",
                                     actionStyle: .destructive) { [weak self] in
            guard let id = self?.diaryList[indexPath.row].id else { return }
            
            self?.diaryList.remove(at: indexPath.row)
            DiaryCoreDataManager.shared.deleteDiary(id: id)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let cancel = AlertActionData(actionTitle: "취소",
                                     actionStyle: .cancel,
                                     completion: nil)
        let actionDataList = [delete, cancel]
        let alertData = alertDataMaker.makeData(title: "진짜요?",
                                                message: "정말로 삭제하시겠어요?",
                                                alertStyle: .alert,
                                                actionDataList: actionDataList)
        let alertController = alertFactory.make(for: alertData)
        
        present(alertController, animated: true)
    }
}
