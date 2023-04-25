//
//  Diary - HomeDiaryController.swift
//  Created by Andrew, Brody.
// 

import UIKit

final class HomeDiaryController: UIViewController {
    private let diaryTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diaryTableView.dataSource = self
        diaryTableView.register(DiaryCell.self, forCellReuseIdentifier: "cell")
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        diaryTableView.rowHeight = UITableView.automaticDimension
        diaryTableView.estimatedRowHeight = 600
        
        view.addSubview(diaryTableView)
        diaryTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            diaryTableView.topAnchor.constraint(equalTo: view.topAnchor),
            diaryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            diaryTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "일기장"
    }
    
}

extension HomeDiaryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DiaryCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}
