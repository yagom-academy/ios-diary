//
//  DiaryListViewController.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/20.
//

import UIKit

class DiaryListViewController: UIViewController {
    private let diaryListTableView = UITableView()
    private let diaryForms: [DiaryForm] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.diaryListTableView.delegate = self
        self.diaryListTableView.dataSource = self
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryForms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = diaryListTableView.dequeueReusableCell(
            withIdentifier: DiaryListTableViewCell.identifier,
            for: indexPath
        ) as? DiaryListTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}

extension DiaryListViewController: UITableViewDelegate { }

