//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class DiaryTableViewController: UIViewController {
    private let diaryListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 70
        return tableView
    }()
    
    private var diaryEntity: [Diary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(diaryListTableView)
        setConstraint()
        fetchData()
        diaryListTableView.dataSource = self
        diaryListTableView.delegate = self
        diaryListTableView.register(DiaryListCell.self, forCellReuseIdentifier: DiaryListCell.reuseIdentifier)
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            diaryListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            diaryListTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            diaryListTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
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
}
