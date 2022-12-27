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
        static let deleteImage = "trash"
        static let shareImage = "square.and.arrow.up"
    }
    
    private var diaries: [Diary]? {
        didSet {
            print(diaries)
        }
    }
    private let coreDataManager = CoreDataManager.shared
    
    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    private var dataSource: UITableViewDiffableDataSource<Int, Diary>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        setNavigationBar()
        setTableViewAnchor()
        setUpTableViewDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        diaries = coreDataManager.fetchDiary()
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
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard let dataSource = dataSource,
              let item = dataSource.itemIdentifier(for: indexPath) else { return nil }
        
        let deleteAction = configureDeleteButton(item: item)
        let shareAction = configureShareButton()
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}

extension DiaryListViewController {
    private func configureDeleteButton(item: Diary) -> UIContextualAction {
        let handler: UIContextualAction.Handler = { [weak self] _, view, handler in
            guard let self = self else { return }
            
            let alert = UIAlertController(
                title: "정말요",
                message: "정말 삭제하시겠어요?",
                diary: item,
                deleteCompletion: { [weak self] _ in
                    guard let self = self else { return }
                    
                    let result = self.deleteSnapshot(item: item)
                    handler(result)
                },
                cancelCompletion: { _ in
                    handler(false)
                }
            )
            
            self.present(alert, animated: true)
        }
        
        let action = UIContextualAction(style: .destructive, title: nil, handler: handler)
        action.backgroundColor = .systemRed
        action.image = UIImage(systemName: Constant.deleteImage)
        
        return action
    }
    
    private func configureShareButton() -> UIContextualAction {
        let handler: UIContextualAction.Handler = { _, _, handler in
            // TODO: ActivityView 띄우는 메서드 추가하기
            // MARK: 넌 누구냐...handler
            handler(false)
        }
        
        let action = UIContextualAction(style: .normal, title: nil, handler: handler)
        action.backgroundColor = .systemBlue
        action.image = UIImage(systemName: Constant.shareImage)
        
        return action
    }
}

// MARK: Business Logic
extension DiaryListViewController {
    private func deleteSnapshot(item: Diary) -> Bool {
        guard let dataSource = dataSource else { return false }
        
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([item])
        dataSource.apply(snapshot)
        
        return true
    }
    
    private func setSnapshot() {
        guard let diaries = diaries else {
            return
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Diary>()
        snapshot.appendSections([.zero])
        snapshot.appendItems(diaries)
        dataSource?.apply(snapshot, animatingDifferences: false)
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
