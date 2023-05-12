//
//  DiaryMainViewController.swift
//  Diary
//
//  Created by Christy, vetto on 2023/04/24.
//

import UIKit

final class DiaryMainViewController: UIViewController {
    private var diaryDataList: [DiaryData] = []
    
    private let diaryTableView: UITableView = {
        let tableView: UITableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        diaryDataList = CoreDataManger.shared.fetchDiary()
        diaryTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        let navigationRightButton = UIBarButtonItem(barButtonSystemItem: .add,
                                                    target: self,
                                                    action: #selector(addDiaryButtonTapped))
        
        navigationItem.rightBarButtonItem = navigationRightButton
        navigationItem.title = "일기장"
    }

    private func configureTableView() {
        view.addSubview(diaryTableView)
        diaryTableView.delegate = self
        diaryTableView.dataSource = self
        diaryTableView.register(DiaryTableViewCell.self,
                                forCellReuseIdentifier: DiaryTableViewCell.identifier)
        
        NSLayoutConstraint.activate([
            diaryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            diaryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    @objc
    private func addDiaryButtonTapped() {
        let diaryEditViewController = DiaryEditViewController(type: .new)
        
        diaryEditViewController.title = DateManger.shared.generateTodayDate()
        navigationController?.pushViewController(diaryEditViewController, animated: true)
    }
}

extension DiaryMainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryDataList.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.identifier,
                                                       for: indexPath) as? DiaryTableViewCell else {
            return UITableViewCell()
        }
        
        cell.accessoryType = .disclosureIndicator
        cell.configureLabel(diaryData: diaryDataList[indexPath.row])
        
        return cell
    }
}

extension DiaryMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diaryEditViewController = DiaryEditViewController(diaryData: diaryDataList[indexPath.row],
                                                              type: .old)
        
        navigationController?.pushViewController(diaryEditViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let share = UIContextualAction(style: .normal, title: nil) { [weak self](_, _, completion) in
            guard let self else { return }
            
            ActivityViewManager().showActivityView(target: self)
            completion(true)
        }
        let delete = UIContextualAction(style: .normal, title: nil) { [weak self](_, _, completion) in
            guard let self,
                  let id = self.diaryDataList[indexPath.row].id else { return }
            
            AlertManager().showDeleteAlert(target: self) {
                CoreDataManger.shared.deleteDiary(id: id)
                self.diaryDataList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
            }
            completion(true)
        }
        
        share.title = "share"
        share.backgroundColor = .systemBlue
        delete.title = "delete"
        delete.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [delete, share])
        
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}
