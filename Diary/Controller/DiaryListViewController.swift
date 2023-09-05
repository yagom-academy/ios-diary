//
//  Diary - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//  Last modified by Maxhyunm, Hamg.

import UIKit

protocol DiaryListDelegate: AnyObject {
    func readCoreData()
    func shareDiary(_ diary: Diary?)
}

final class DiaryListViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let dateFormatter = DateFormatter()
    private let container = CoreDataManager.shared.persistentContainer
    private var diaryList = [Diary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        readCoreData()
        configureUI()
        setupNavigationBarButton()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        readCoreData()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        self.title = "일기장"
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupNavigationBarButton() {
        let addDiary = UIAction(image: UIImage(systemName: "plus")) { [weak self] _ in
            guard let self else { return }
            let createDiaryView = CreateDiaryViewController()
            createDiaryView.delegate = self
            self.navigationController?.pushViewController(createDiaryView, animated: true)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(primaryAction: addDiary)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DiaryListTableViewCell.self, forCellReuseIdentifier: DiaryListTableViewCell.identifier)
    }
}

extension DiaryListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        diaryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryListTableViewCell.identifier,
                                                       for: indexPath) as?
                DiaryListTableViewCell else { return UITableViewCell() }
        
        let diaryEntity = diaryList[indexPath.row]
        guard let title = diaryEntity.title,
              let createdAt = diaryEntity.createdAt,
              let body = diaryEntity.body else { return UITableViewCell() }
        let date = dateFormatter.formatToString(from: createdAt, with: "YYYY년 MM월 dd일")
        
        cell.setModel(title: title, date: date, body: body)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let diaryToEdit = diaryList[indexPath.row]
        let createVC = CreateDiaryViewController(diaryToEdit)
        
        createVC.delegate = self
        navigationController?.pushViewController(createVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) ->
    UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "") { (_, _, success: @escaping (Bool) -> Void) in
            let selectedDiary = self.diaryList[indexPath.row]
            
            CoreDataManager.shared.deleteDiary(selectedDiary)
            self.readCoreData()
            success(true)
        }
        
        let share = UIContextualAction(style: .normal, title: "") { (_, _, success: @escaping (Bool) -> Void) in
            let selectedDiary = self.diaryList[indexPath.row]
            
            self.shareDiary(selectedDiary)
            success(true)
        }
        
        delete.backgroundColor = .systemRed
        delete.image = UIImage(systemName: "trash.fill")
        share.backgroundColor = .systemBlue
        share.image = UIImage(systemName: "square.and.arrow.up")
        
        return UISwipeActionsConfiguration(actions: [delete, share])
    }
}

extension DiaryListViewController: DiaryListDelegate, AlertDisplayable {
    func readCoreData() {
        do {
            diaryList = try container.viewContext.fetch(Diary.fetchRequest())
            tableView.reloadData()
        } catch {
            let cancelAction = UIAlertAction(title: "확인", style: .cancel)
            showAlert(title: "로드 실패", message: "데이터를 불러오지 못했습니다.", actions: [cancelAction])
        }
    }
    
    func shareDiary(_ diary: Diary?) {
        guard let diary,
              let title = diary.title,
              let createdAt = diary.createdAt,
              let body = diary.body else {
            return
        }
        
        let date = dateFormatter.formatToString(from: createdAt, with: "YYYY년 MM월 dd일")
        let shareText = "제목: \(title)\n작성일자: \(date)\n내용: \(body)"
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}
