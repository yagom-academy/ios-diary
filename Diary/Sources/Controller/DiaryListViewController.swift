//
//  Diary - DiaryListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    enum Constant {
        static let assetName = "sample"
        static let navigationTitle = "일기장"
    }
    
    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    private var dataSource: UITableViewDiffableDataSource<Int, Diary>?
    private var diaries: [Diary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        setNavigationBar()
        fetchData()
        setTableViewAnchor()
        setUpTableViewDataSource()
        setSnapshot()
    }
}

// MARK: UITableView DataSource
extension DiaryListViewController {
    private func setUpTableViewDataSource() {
        tableView.register(DiaryListCell.self, forCellReuseIdentifier: DiaryListCell.identifier)
        
        dataSource = UITableViewDiffableDataSource<Int, Diary>(
            tableView: tableView
        ) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: DiaryListCell.identifier,
                for: indexPath
            ) as? DiaryListCell else {
                return UITableViewCell()
            }
            
            cell.diary = item
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
    }
}

// MARK: UITableView Delegate
extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let items = diaries else { return }
        let diary = items[indexPath.row]
        
        presentDiaryDetailView(diary: diary)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: Business Logic
extension DiaryListViewController {
    private func fetchData() {
        guard let dataAsset = NSDataAsset(name: Constant.assetName) else {
            return
        }
        
        diaries = try? JSONDecoder().decode([Diary].self, from: dataAsset.data)
    }
    
    private func setSnapshot() {
        guard let diaries = diaries else {
            return
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Diary>()
        snapshot.appendSections([.zero])
        snapshot.appendItems(diaries)
        dataSource?.apply(snapshot)
    }
}

// MARK: Present Method
extension DiaryListViewController {
    private func presentDiaryDetailView(diary: Diary? = nil) {
        let viewController = DiaryDetailViewController()
        viewController.setDiary(with: diary)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: UI Configuration
extension DiaryListViewController {
    private func setTableViewAnchor() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        tableView.anchor(
            top: safeArea.topAnchor,
            leading: safeArea.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: safeArea.trailingAnchor
        )
    }
    
    private func setNavigationBar() {
        navigationItem.setNavigationTitle(title: Constant.navigationTitle)
        
        let presentAction = UIAction { _ in
            self.presentDiaryDetailView()
        }
        navigationItem.setRightButton(systemName: .add, action: presentAction)
        navigationController?.setDefaultNavigationAppearance()
    }
}
