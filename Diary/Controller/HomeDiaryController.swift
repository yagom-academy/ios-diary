//
//  Diary - HomeDiaryController.swift
//  Created by Andrew, Brody.
// 

import UIKit

final class HomeDiaryController: UIViewController {
    private let diaryTableView = UITableView()
    private let localizedDateFormatter = DateFormatter(
        languageIdentifier: Locale.preferredLanguages.first ?? Locale.current.identifier
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        configureUI()
    }
    
    private func setupTableView() {
        diaryTableView.dataSource = self
        diaryTableView.delegate = self
        diaryTableView.register(DiaryCell.self, forCellReuseIdentifier: DiaryCell.identifier)
    }

    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()        
        view.addSubview(diaryTableView)
        diaryTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            diaryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            diaryTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddDiaryButton)
        )
    }
    
    @objc private func didTapAddDiaryButton() {
        navigationController?.pushViewController(ProcessViewController(type: .create), animated: true)
    }
    
}

extension HomeDiaryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DiaryCell.identifier,
            for: indexPath
        ) as? DiaryCell,
              let diary = diaries[safe: indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configureData(data: diary, localizedDateFormatter: localizedDateFormatter)
    
        return cell
    }
}

extension HomeDiaryController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addDiaryViewController = ProcessViewController(diaryItem: diaries[indexPath.row], type: .update)
        navigationController?.pushViewController(addDiaryViewController, animated: true)
    }
}
