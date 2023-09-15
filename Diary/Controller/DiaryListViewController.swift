//
//  Diary - DiaryListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    
    // MARK: - Private Property
    private let diaryReader: DiaryReadable
    private let diaryManager: DiaryManageable
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var dataSource: UITableViewDiffableDataSource = {        
        let dataSource = UITableViewDiffableDataSource<Section, DiaryEntry>(tableView: tableView, cellProvider: { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.identifier, for: indexPath) as? DiaryTableViewCell else {
                return UITableViewCell()
            }
            
            cell.setupContent(item)
            
            return cell
        })
        
        return dataSource
    }()
    
    // MARK: - Life Cycle
    init(diaryReader: DiaryReadable, diaryManager: DiaryManageable) {
        self.diaryReader = diaryReader
        self.diaryManager = diaryManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIObject()
        configureUI()
        setupConstraints()
        setupContentTableView()
    }
}

// MARK: - Setup Data
extension DiaryListViewController {
    @objc private func setupContentTableView() {
        do {
            let diaryEntrys = try diaryReader.diaryEntrys()
            var snapshot = NSDiffableDataSourceSnapshot<Section, DiaryEntry>()
            snapshot.appendSections([.main])
            snapshot.appendItems(diaryEntrys)
            dataSource.apply(snapshot)
        } catch {
            presentFailDataLoadAlert()
        }
    }
}

// MARK: - Setup UI Object
extension DiaryListViewController {
    private func setupUIObject() {
        setupView()
        setupNavigationItem()
        setupTableView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationItem() {
        let plusButton = UIBarButtonItem(image: UIImage(systemName: NameSpace.plus), style: .plain, target: self, action: #selector(pushDiaryViewController))
        
        navigationItem.title = NameSpace.diary
        navigationItem.rightBarButtonItem = plusButton
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
    }
}

// MARK: - Push & Present Controller
extension DiaryListViewController {
    @objc private func pushDiaryViewController() {
        let diaryViewController = DiaryViewController(diaryManager: diaryManager, diaryEntry: nil)
        diaryViewController.delegate = self
        
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    @objc private func presentFailAlert() {
        AlertManager.presentFailAlert(to: self, with: NameSpace.failMessage)
    }
    
    private func presentFailDataLoadAlert() {
        AlertManager.presentFailAlert(to: self, with: NameSpace.failLoadDataMessage)
    }
    
    private func presentDeleteAlert(diaryEntry: DiaryEntry) {
        AlertManager.presentDeleteAlert(to: self) { [weak self] _ in
            guard let self else {
                return
            }
            
            do {
                try diaryManager.deleteDiary(diaryEntry)
                setupContentTableView()
            } catch {
                presentFailAlert()
            }
        }
    }
}

// MARK: - TableView Delegate
extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let diaryEntry = try diaryReader.diaryEntrys()[indexPath.row]
            let diaryViewController = DiaryViewController(diaryManager: diaryManager, diaryEntry: diaryEntry)
            diaryViewController.delegate = self
            
            navigationController?.pushViewController(diaryViewController, animated: true)
        } catch {
            presentFailDataLoadAlert()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title: NameSpace.share) { [weak self] (_, _, success: @escaping (Bool) -> Void) in
            guard let self else {
                return
            }
            
            do {
                let diaryEntrys = try diaryReader.diaryEntrys()
                let diaryEntry = diaryEntrys[indexPath.row]
                ActivityViewManager.presentActivityView(to: self, with: diaryEntry)
                success(true)
            } catch {
                presentFailAlert()
                success(false)
            }
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: NameSpace.delete) { [weak self] (_, _, success: @escaping (Bool) -> Void) in
            guard let self else {
                return
            }
            
            do {
                let diaryEntrys = try diaryReader.diaryEntrys()
                presentDeleteAlert(diaryEntry: diaryEntrys[indexPath.row])
                success(true)
            } catch {
                presentFailAlert()
                success(false)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}

// MARK: - DiaryViewControllerDelegate
extension DiaryListViewController: DiaryViewControllerDelegate {
    func diaryViewController(_ diaryViewController: DiaryViewController, updateDiary isSuccess: Bool) {
        if isSuccess {
            setupContentTableView()
        }
    }
}

// MARK: - Configure UI
extension DiaryListViewController {
    private func configureUI() {
        configureView()
    }
    
    private func configureView() {
        view.addSubview(tableView)
    }
}

// MARK: - Setup Constraint
extension DiaryListViewController {
    private func setupConstraints() {
        setupTableViewConstraint()
    }
    
    private func setupTableViewConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}

// MARK: - TableView Section
extension DiaryListViewController {
    private enum Section {
        case main
    }
}

// MARK: - Name Space
extension DiaryListViewController {
    private enum NameSpace {
        static let diary = "일기장"
        static let plus = "plus"
        static let share = "share..."
        static let delete = "Delete"
        static let failLoadDataMessage = "데이터 로드에 실패했습니다."
        static let failMessage = "작업에 실패했습니다."
    }
}
