//
//  DiaryListViewController.swift
//  Diary
//
//  Created by 재재, 그루트 on 2022/08/17.
//

import UIKit

final class DiaryListViewController: UIViewController {
    // MARK: - properties

    private var tableView = UITableView()
    private var diaryData = DiaryDataManager().provider

    // MARK: - view life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        configureNavigationBarItems()
        configureView()
        configureViewLayout()
    }

    // MARK: - methods

    private func configureNavigationBarItems() {
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add,
                                         target: self,
                                         action: #selector(tappedPlusButton))

        navigationItem.rightBarButtonItem = plusButton
        navigationItem.title = Design.navigationTitle
    }

    private func configureView() {
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DiaryTableViewCell.self,
                            forCellReuseIdentifier: DiaryTableViewCell.reuseIdentifier)
    }

    private func configureViewLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
    }

    @objc private func tappedPlusButton() {
        navigationController?.pushViewController(DiaryRegisterViewController(), animated: true)
    }
}

// MARK: - extension

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        diaryData.diaryItems?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.reuseIdentifier)
                as? DiaryTableViewCell else { return UITableViewCell() }

        cell.titleLabel.text = diaryData.diaryItems?[indexPath.row].title
        cell.dateLabel.text = diaryData.diaryItems?[indexPath.row].createdAt.convertDate()
        cell.bodyLabel.text = diaryData.diaryItems?[indexPath.row].body

        return cell
    }
}

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diaryDetailViewController = DiaryDetailViewController()
        diaryDetailViewController.diaryDetailData = diaryData.diaryItems?[indexPath.row]
        
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
}

private enum Design {
    static let navigationTitle = "일기장"
}
