//
//  Diary - DiaryListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    
    // MARK: - Private Property
    private let diaryStore: DiaryStorageProtocol
    
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
    init(diaryStore: AssetDiaryStorage) {
        self.diaryStore = diaryStore
        
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
    private func setupContentTableView() {
        do {
            let diaryEntrys = try diaryStore.diaryEntrys()
            var snapshot = NSDiffableDataSourceSnapshot<Section, DiaryEntry>()
            snapshot.appendSections([.main])
            snapshot.appendItems(diaryEntrys)
            dataSource.apply(snapshot)
        } catch {
            print(error.localizedDescription)
            presentFailAlert()
        }
    }
}

// MARK: - Push & Present Controller
extension DiaryListViewController {
    @objc private func pushDiaryViewController() {
        let diaryViewController = DiaryViewController(diaryStore: diaryStore, diaryEntry: nil)
        
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    private func presentFailAlert() {
        let alertAction = UIAlertAction(title: NameSpace.check, style: .default)
        let alert = UIAlertController.customAlert(alertTile: NameSpace.fail, alertMessage: NameSpace.loadDataFail, preferredStyle: .alert, alertActions: [alertAction])
        
        self.present(alert, animated: true)
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

// MARK: - TableView Delegate
extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let diaryEntry = try diaryStore.diaryEntrys()[indexPath.row]
            let diaryViewController = DiaryViewController(diaryStore: diaryStore, diaryEntry: diaryEntry)
            
            navigationController?.pushViewController(diaryViewController, animated: true)
        } catch {
            print(error.localizedDescription)
            presentFailAlert()
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
        static let fail = "실패"
        static let loadDataFail = "데이터 로드에 실패했습니다."
        static let check = "확인"
    }
}
