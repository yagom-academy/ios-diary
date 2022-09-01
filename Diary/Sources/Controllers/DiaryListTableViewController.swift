//
//  Diary - DiaryListTableViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListTableViewController: UIViewController, CoreDataProcessing {
    private enum Section {
        case main
    }

    private typealias DiffableDataSource = UITableViewDiffableDataSource<Section, DiaryContents>
    private var dataSource: DiffableDataSource?
    private var snapshot = NSDiffableDataSourceSnapshot<Section, DiaryContents>()
    private let diaryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            DiaryTableViewCell.self,
            forCellReuseIdentifier: DiaryTableViewCell.reuseIdentifier
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()

    private let detailDiaryViewController = DiaryDetailViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        configureAttributes()
        configureLayout()
        configureSnapshot()
        configureDataSource()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        snapshot.reloadItems(getDiaryContent())
        dataSource?.apply(snapshot)
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
        dataSource = DiffableDataSource(
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
        snapshot.appendSections([.main])
        snapshot.appendItems(getDiaryContent())
    }

    private func getDiaryContent() -> [DiaryContents] {
        guard let context = context,
              let diaryContents = try? context.fetch(DiaryContents.fetchRequest()) else {
                  return [DiaryContents()]
        }
        
        return diaryContents
    }
}

extension DiaryListTableViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let diaryContent = snapshot.itemIdentifiers[indexPath.item]
        weak var sendDataDelegate: (SendDataDelegate)? = detailDiaryViewController
        
        sendDataDelegate?.sendData(
            diaryContent,
            isExist: true
        )
        
        navigationController?.pushViewController(
            detailDiaryViewController,
            animated: true
        )
    }
    
    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .normal,
            title: "Delete"
        ) { [self] _, _, _ in
            let removableContent = self.snapshot.itemIdentifiers[indexPath.item]
            
            self.delete(removableContent) { error in
                DispatchQueue.main.async {
                    self.showErrorAlert(error: error)
                }
            }
            self.snapshot.deleteItems([removableContent])
            self.dataSource?.apply(
                snapshot,
                animatingDifferences: true
            )
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
