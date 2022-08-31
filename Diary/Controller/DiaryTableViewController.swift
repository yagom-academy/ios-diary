//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryTableViewController: UIViewController {
    private let diaryListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 70
        tableView.register(cellWithClass: DiaryListCell.self)
        return tableView
    }()
    
    private var diaryItems: [DiaryItem] = []
    private let dataManager = DiaryDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationItem()
        fetchData(manager: dataManager)
        fetchWeather()
    }
    
    func fetchWeather() {
        let weather = WeatherSessionManager()
        weather.requestWeatherInfomation(at: "Seoul") { (response) in
            switch response {
            case .success(let data):
                print(data)
            case .failure(let data):
                print(data)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData(manager: dataManager)
        diaryListTableView.reloadData()
    }
    
    @objc private func addDiaryButtonDidTapped() {
        self.performSegue(withIdentifier: "AddDiarySegue", sender: self)
    }
    
    private func configureNavigationItem() {
        navigationItem.title = "일기장"
        let addDiaryButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addDiaryButtonDidTapped))
        navigationItem.rightBarButtonItem = addDiaryButton
    }
    
    private func configureTableView() {
        self.view.addSubview(diaryListTableView)
        setupConstraint()
        diaryListTableView.dataSource = self
        diaryListTableView.delegate = self
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            diaryListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            diaryListTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            diaryListTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            diaryListTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func fetchData(manager: DataManageable) {
        guard let diaryItems = manager.fetchDiary() else { return }
        
        self.diaryItems = diaryItems
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ManageDiarySegue" {
            guard let manageViewController = segue.destination as? ManageDiaryViewController else { return }
            guard let diary = sender as? DiaryItem else { return }
            manageViewController.getDiaryData(data: diary)
        }
    }
}

extension DiaryTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.diaryListTableView.dequeueReusableCell(withIdentifier: DiaryListCell.reuseIdentifier, for: indexPath) as? DiaryListCell else { return UITableViewCell() }
        
        cell.accessoryType = .disclosureIndicator
        cell.configure(with: diaryItems[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ManageDiarySegue", sender: diaryItems[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title: "공유") { [weak self]_, _, _ in
            guard let self = self else { return }
            let shareText = self.diaryItems[indexPath.row]
            let shareObject: [String] = [shareText.title + shareText.body]
            
            let activityViewController = UIActivityViewController(activityItems: shareObject, applicationActivities: nil)
            
            self.present(activityViewController, animated: true)
        }
        
        shareAction.backgroundColor = .systemBlue
        
        let deleteAction = UIContextualAction(style: .normal, title: "삭제") { [weak self]_, _, _ in
            guard let self = self else { return }
            self.deleteDiaryItem(indexPath: indexPath)
        }
        
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
    
    private func deleteDiaryItem(indexPath: IndexPath) {
        let confirmAlert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "취소", style: .cancel)
        let yesAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            DiaryDataManager.shared.deleteDiary(id: self.diaryItems[indexPath.row].id)
            self.fetchData(manager: self.dataManager)
            self.diaryListTableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        confirmAlert.addAction(noAction)
        confirmAlert.addAction(yesAction)
        self.present(confirmAlert, animated: true)
    }
}
