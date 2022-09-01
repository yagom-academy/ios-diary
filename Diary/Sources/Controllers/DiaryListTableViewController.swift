//
//  Diary - DiaryListTableViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListTableViewController: UIViewController, CoreDataProcessing {
    private let diaryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            DiaryTableViewCell.self,
            forCellReuseIdentifier: DiaryTableViewCell.reuseIdentifier
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        configureAttributes()
        configureLayout()
        configureSnapshot()
        configureDataSource()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        dataManager.dataSource?.apply(dataManager.snapshot)
    }
    
    private func configureAttributes() {
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(touchAddButton)
        )
        
        diaryTableView.delegate = self
    }
    
    @objc func touchAddButton() {
        navigationController?.pushViewController(
            DiaryDetailViewController(),
            animated: true
        )
    }

    private func configureLayout() {
        view.addSubview(diaryTableView)
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            diaryTableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            diaryTableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
            diaryTableView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            diaryTableView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            )
        ])
    }
    
    private func configureDataSource() {
        dataManager.dataSource = UITableViewDiffableDataSource<Section, DiaryContents>(
            tableView: diaryTableView,
            cellProvider: { tableView, indexPath, itemIdentifier in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: DiaryTableViewCell.reuseIdentifier,
                    for: indexPath
                ) as? DiaryTableViewCell else {
                    return nil
                }
                
                cell.setupComponents(item: itemIdentifier)
                
                return cell
            })
    }

    private func configureSnapshot() {
        dataManager.snapshot.appendSections([.main])
        dataManager.snapshot.appendItems(getDiaryContent())
    }
}

extension DiaryListTableViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let detailDiaryViewController = DiaryDetailViewController()
        let diaryContent = dataManager.snapshot.itemIdentifiers[indexPath.item]
        weak var sendDataDelegate: (SendDataDelegate)? = detailDiaryViewController
        
        sendDataDelegate?.sendData(
            diaryContent,
            isExist: true
        )
        
        navigationController?.pushViewController(
            detailDiaryViewController,
            animated: true
        )
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .normal,
            title: "Delete"
        ) { [weak self] _, _, _ in
            guard let self = self else {
                return
            }
            
            let removableContent = self.dataManager.snapshot.itemIdentifiers[indexPath.item]
            
            self.delete(removableContent) { error in
                DispatchQueue.main.async {
                    self.showErrorAlert(error: error)
                }
            }
            self.dataManager.snapshot.deleteItems([removableContent])
            self.dataManager.dataSource?.apply(
                self.dataManager.snapshot,
                animatingDifferences: true
            )
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
