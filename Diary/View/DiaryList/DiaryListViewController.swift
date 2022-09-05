//
//  Diary - DiaryListViewController.swift
//  Created by Hugh, Derrick on 2022/08/16.
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class DiaryListViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<Section, DiaryContent>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, DiaryContent>
    
    enum Section {
        case main
    }
    
    private enum AlertConst {
        static let confirm = "확인"
        static let notification = "알림"
    }

    private lazy var dataSource = self.configureDataSource()
    private var diaryViewModel: DiaryViewModelLogic?
    
    private let diaryListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        return searchController
    }()

    init(viewModel: DiaryViewModelLogic) {
        self.diaryViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefault()
        configureLayout()
        initializeViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        diaryViewModel?.fetch()
    }
    
    func initializeViewModel() {
        guard let data = diaryViewModel?.diaryContents else {
            return
        }
        updateDataSource(data: data)
        
        diaryViewModel?.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let data = self?.diaryViewModel?.diaryContents else {
                    return
                }
                
                self?.updateDataSource(data: data)
            }
        }
        
        diaryViewModel?.showAlertClosure = { [weak self] in
            if let message = self?.diaryViewModel?.alertMessage {
                DispatchQueue.main.async {
                    self?.presentConfirmAlert(message)
                }
            }
        }
        
        diaryViewModel?.fetchWeatherData()
    }
    
    private func presentConfirmAlert(_ message: String) {
        let alertController = UIAlertController(title: AlertConst.notification, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: AlertConst.confirm, style: .default, handler: nil)
        
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupDefault() {
        self.view.backgroundColor = .white
        self.diaryListTableView.delegate = self
        self.diaryListTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        
        diaryListTableView.tableHeaderView = self.searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.delegate = self

        self.title = "일기장"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTappedAddButton))
    }
        
    private func configureDataSource() -> DataSource {
        dataSource = DataSource(tableView: diaryListTableView, cellProvider: { tableView, indexPath, content -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.identifier, for: indexPath) as? DiaryTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configureUI(data: content)
            cell.accessoryType = .disclosureIndicator
            
            return cell
        })
        
        return dataSource
    }
    
    private func updateDataSource(data: [DiaryContent]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
    
        dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
    }
    
    private func configureLayout() {
        self.view.addSubview(diaryListTableView)
        
        NSLayoutConstraint.activate([
            diaryListTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            diaryListTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            diaryListTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            diaryListTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
        
    @objc private func didTappedAddButton() {
        guard let viewModel = diaryViewModel else {
            return
        }

        let addDiaryViewController = DiaryPostViewController(viewModel: viewModel)
        
        self.navigationController?.pushViewController(addDiaryViewController, animated: true)
    }
}

// MARK: TableVeiwDelegate

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = diaryViewModel,
              let data = viewModel.diaryContents?[safe: indexPath.row] else {
            return
        }
        
        diaryViewModel?.createdAt = data.createdAt
        let diaryContentViewController = DiaryContentViewController(viewModel: viewModel)
        
        diaryContentViewController.configureUI(data: data)
        
        self.navigationController?.pushViewController(diaryContentViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "삭제") { [weak self](UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            guard let date = self?.diaryViewModel?.diaryContents?[safe: indexPath.row]?.createdAt else {
                return
            }

            self?.diaryViewModel?.createdAt = date
            self?.diaryViewModel?.remove()
            success(true)
        }
        delete.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions:[delete])
    }
}

extension DiaryListViewController: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        diaryViewModel?.filterData(text: text)
        diaryListTableView.reloadData()
    }
}
