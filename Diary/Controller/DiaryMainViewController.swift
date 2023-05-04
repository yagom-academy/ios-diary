//
//  DiaryMainViewController.swift
//  Diary
//
//  Created by Christy, vetto on 2023/04/24.
//

import UIKit

final class DiaryMainViewController: UIViewController {
    private let diaryTableView: UITableView = {
        let tableView: UITableView = UITableView()

        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    private var diaryDatas: [DiaryData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        diaryDatas = CoreDataManger.shared.fetchDiary()
        self.diaryTableView.reloadData()
    }

    private func configureUI() {
        view.backgroundColor = .systemBackground
        self.navigationItem.title = "일기장"
        
        let navigationRightButton = UIBarButtonItem(barButtonSystemItem: .add,
                                                    target: self,
                                                    action: #selector(addDiaryButtonTapped))
        
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
    
    @objc private func addDiaryButtonTapped() {
        let diaryEditViewController = DiaryEditViewController(type: .new)
        diaryEditViewController.title = DateManger.shared.generateTodayDate()
        navigationController?.pushViewController(diaryEditViewController, animated: true)
    }
}

extension DiaryMainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryDatas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.identifier,
                                                       for: indexPath) as? DiaryTableViewCell else {
            return UITableViewCell()
        }
        
        cell.accessoryType = .disclosureIndicator
        cell.configureLabel(diaryData: diaryDatas[indexPath.row])
        
        return cell
    }
}

extension DiaryMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diaryEditViewController = DiaryEditViewController(diaryData: diaryDatas[indexPath.row],
                                                              type: .old)
        navigationController?.pushViewController(diaryEditViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let share = UIContextualAction(style: .normal, title: nil) { (_, _, completion) in
            let shareText: String = "share text test!"
            var shareObject = [Any]()
            
            shareObject.append(shareText)
            
            let activityViewController = UIActivityViewController(activityItems: shareObject,
                                                                  applicationActivities: nil)

            self.present(activityViewController, animated: true)
            completion(true)
        }
        
        let delete = UIContextualAction(style: .normal, title: nil) { (_, _, completion) in
            CoreDataManger.shared.deleteDiary(id: self.diaryDatas[indexPath.row].id ?? UUID())
            self.diaryDatas.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            completion(true)
        }
        
        share.title = "share"
        share.backgroundColor = .systemBlue
        
        delete.title = "delete"
        delete.backgroundColor = .systemRed
//        action.image = UIImage(systemName: "trash")
        
        let configuration = UISwipeActionsConfiguration(actions: [delete, share])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
