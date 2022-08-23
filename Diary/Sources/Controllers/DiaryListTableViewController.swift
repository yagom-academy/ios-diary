//
//  Diary - DiaryListTableViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListTableViewController: UIViewController {
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
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private var diaryContent = [DiaryContents]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        configureAttributes()
        configureLayout()
        configureDataSource()
        configureSnapshot()
        fetchDiaryContents()
    }
    
    private func configureAttributes() {
        view.backgroundColor = .white
        view.addSubview(diaryTableView)
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
            DetailDiaryViewController(),
            animated: true
        )
    }
    
    private func configureLayout() {
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
                withIdentifier: "DiaryTableViewCell",
                for: indexPath
            ) as? DiaryTableViewCell else {
                return nil
            }
            
            cell.setComponents(item: itemIdentifier)
            
            return cell
        })
    }
    
    private func configureSnapshot() {
        let diarySample: [DiaryContents]? = diaryContent
        guard let diarySample = diarySample else {
            return
        }
        
        snapshot.appendSections([.main])
        snapshot.appendItems(diarySample)
        
        dataSource?.apply(snapshot)
    }
    
    private func fetchDiaryContents() {
        do {
            guard let context = context else {
                return
            }
            diaryContent = try context.fetch(DiaryContents.fetchRequest())
            
            DispatchQueue.main.async {
                self.diaryTableView.reloadData()
            } //
        } catch {
            print("error!!!")
        }
    }
}

extension DiaryListTableViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let diaryContent = snapshot.itemIdentifiers[indexPath.item]
        let detailDiaryViewController = DetailDiaryViewController()
        weak var sendDataDelegate: (SendDataDelegate)? = detailDiaryViewController
        
        sendDataDelegate?.sendData(diaryContent)
        navigationController?.pushViewController(
            detailDiaryViewController,
            animated: true
        )
    }
}
