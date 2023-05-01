//
//  Diary - DiaryListViewController.swift
//  Created by Rhode, 무리.
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreData

final class DiaryListViewController: UIViewController {
    private let diaryDataDecoder = DiaryDataDecoder()
    var container: NSPersistentContainer?
    var diaries: [Entity]?
//    private var diary: [Diary]? {
//        return diaryDataDecoder.decodeDiaryData()
//    }
        
    private let diaryListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(DiaryListCell.self, forCellReuseIdentifier: DiaryListCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSubview()
        configureConstraint()
    }
    
    func fetchDiaryData() {
        do {
            diaries = try self.container?.viewContext.fetch(Entity.fetchRequest()) as? [Entity]
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        title = NameSpace.diary
        
        diaryListTableView.dataSource = self
        diaryListTableView.delegate = self
        
        let addDiaryButton = UIBarButtonItem(barButtonSystemItem: .add,
                                             target: self,
                                             action: #selector(addDiary))
        navigationItem.rightBarButtonItem = addDiaryButton
    }
    
    @objc
    private func addDiary() {
        let detailDiaryViewController = DetailDiaryViewController()
        navigationController?.pushViewController(detailDiaryViewController, animated: true)
    }
    
    private func configureSubview() {
        view.addSubview(diaryListTableView)
    }
    
    private func configureConstraint() {
        NSLayoutConstraint.activate([
            diaryListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            diaryListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let diaries else { return 0 }
        
        return diaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryListCell.identifier) as? DiaryListCell else {
            return DiaryListCell()
        }
        
        cell.accessoryType = .disclosureIndicator
        
        guard let diaries else { return DiaryListCell() }
        
        cell.configureContent(data: diaries[indexPath.row])

        return cell
    }
}

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailDiaryViewController = DetailDiaryViewController()
        navigationController?.pushViewController(detailDiaryViewController, animated: true)
        
        guard let diaries else { return }
        
        detailDiaryViewController.configureContent(diary: diaries[indexPath.row])
    }
}

private enum NameSpace {
    static let diary = "일기장"
}
