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
    
    private var diaryEntity: [Diary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationItem()
        fetchData()
    }
    
    @objc private func addDiaryButtonDidTapped() {
        guard let addDiaryViewController = storyboard?.instantiateViewController(withIdentifier: "AddDiaryViewController") else { return }
        self.navigationController?.pushViewController(addDiaryViewController, animated: true)
    }
    
    private func configureNavigationItem() {
        navigationItem.title = "일기장"
        let addDiaryButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addDiaryButtonDidTapped))
        navigationItem.rightBarButtonItem = addDiaryButton
    }
    
    private func configureTableView() {
        self.view.addSubview(diaryListTableView)
        setConstraint()
        diaryListTableView.dataSource = self
        diaryListTableView.delegate = self
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            diaryListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            diaryListTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            diaryListTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            diaryListTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func fetchData() {
        let jsonParser = JSONParser()
        
        do {
            diaryEntity = try jsonParser.fetch()
        } catch let error as JSONError {
            print(error.message)
        } catch {
            print("Unexpected Error")
        }
    }
}

extension DiaryTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryEntity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.diaryListTableView.dequeueReusableCell(withIdentifier: DiaryListCell.reuseIdentifier, for: indexPath) as? DiaryListCell else { return UITableViewCell() }
        
        cell.accessoryType = .disclosureIndicator
        cell.configure(with: diaryEntity[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let diaryDetailViewController = storyboard?.instantiateViewController(withIdentifier: "DiaryDetailViewController") else { return }
        self.navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
}
