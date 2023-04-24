//
//  DiaryItem.swift
//  Diary
//
//  Created by Christy, vetto on 2023/04/24.
//

import UIKit

final class ViewController: UIViewController {
    private let diaryTableView: UITableView = {
        let tableView: UITableView = UITableView()

        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    private let diaryItems: [DiaryItem] = AssetDecoder.decodeJson()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }

    private func configureUI() {
        view.backgroundColor = .white
    }

    private func configureTableView() {
        view.addSubview(diaryTableView)

        diaryTableView.delegate = self
        diaryTableView.dataSource = self

        NSLayoutConstraint.activate([
            diaryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            diaryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.identifier,
                                                       for: indexPath) as? DiaryTableViewCell else {
            return UITableViewCell()
        }

        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
}
