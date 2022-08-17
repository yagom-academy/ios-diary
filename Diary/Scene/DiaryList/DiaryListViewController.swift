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
        navigationItem.title = "일기장"
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
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    @objc private func tappedPlusButton() {
        print("+ 버튼이 눌렸습니다.")
    }
}

// MARK: - extension

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension DiaryListViewController: UITableViewDelegate {
}
