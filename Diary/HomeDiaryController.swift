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
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(diaryTableView)
        diaryTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            diaryTableView.topAnchor.constraint(equalTo: view.topAnchor),
            diaryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            diaryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            diaryTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension HomeDiaryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
