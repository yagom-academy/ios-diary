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
        self.navigationItem.title = "일기장"
        
        let navigationRightButton = UIBarButtonItem(barButtonSystemItem: .add,
                                     target: self,
                                     action: #selector(addDiary))
        
        self.navigationItem.rightBarButtonItem = navigationRightButton
    }

    private func configureTableView() {
        view.addSubview(diaryTableView)
        diaryTableView.register(DiaryTableViewCell.self,
                                forCellReuseIdentifier: DiaryTableViewCell.identifier)
        diaryTableView.delegate = self
        diaryTableView.dataSource = self

        NSLayoutConstraint.activate([
            diaryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            diaryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    @objc private func addDiary() {
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
        
        cell.accessoryType = .disclosureIndicator
        cell.configureLabel(diaryItem: diaryItems[indexPath.row])
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
