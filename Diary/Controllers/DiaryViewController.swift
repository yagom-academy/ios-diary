//
//  Diary - ViewController.swift
//  Created by Finnn, 수꿍 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class DiaryViewController: UIViewController {
    
    // MARK: - Properties

    var dataSource: UITableViewDiffableDataSource<Section, DiarySampleData>?
    private let diaryView = DiaryListView()
    private var diarySampleData: [DiarySampleData]?
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = diaryView
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseDiaryData()
        configureNavigationItems()
        registerTableView()
        configureDataSource()
        configureDelgate()
    }

    // MARK: - Methods
    
    private func parseDiaryData() {
        let parsedData: Result<[DiarySampleData], Error> = JSONData.parse(name: AssetData.sample)
        switch parsedData {
        case .success(let data):
            diarySampleData = data
        case .failure(let error):
            presentErrorAlert(error)
        }
    }
    
    private func presentErrorAlert(_ error: (Error)) {
        let errorAlert = UIAlertController(
            title: "Error!",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(
            title: "확인",
            style: .default
        )
        
        errorAlert.addAction(confirmAction)
        
        present(
            errorAlert,
            animated: true
        )
    }
    private func configureNavigationItems() {
        title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: SystemImage.plus),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(plusButtonDidTapped))
    }
    
    @objc private func plusButtonDidTapped() {
        goToDiaryContentsViewController()
    }
    
    private func goToDiaryContentsViewController() {
        navigationController?.pushViewController(DiaryContentsViewController(),
                                                 animated: true)
    }
    
    private func configureSnapshot() -> NSDiffableDataSourceSnapshot<Section, DiarySampleData>? {
        guard let diarySampleData = diarySampleData else {
            return nil
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, DiarySampleData>()
        snapshot.appendSections([.main])
        snapshot.appendItems(diarySampleData)
        let tableView = diaryView.tableView
        
        return snapshot
    }
    
    private func configureDataSource() {
        guard let view = view as? DiaryView,
              let snapshot = configureSnapshot() else {
            return
        }
        
        let tableView = diaryView.tableView
        
        dataSource = UITableViewDiffableDataSource<Section, DiarySampleData>(tableView: tableView, cellProvider: { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier,
                                                           for: indexPath) as? CustomCell else {
                return nil
            }
            cell.titleLabel.text = item.title
            cell.dateLabel.text = item.createdAt.formatToStringDate()
            cell.contentLabel.text = item.body
            cell.accessoryType = .disclosureIndicator
            
            return cell
        })
        
        dataSource?.apply(snapshot)
    }
    
    private func configureSnapshot() -> NSDiffableDataSourceSnapshot<Section, DiarySampleData>? {
        guard let diarySampleData = diarySampleData else {
            return nil
        }
        
        
    private func configureDelgate() {
        diaryView.tableView.delegate = self
    }
}

// MARK: - UITableViewDelegate

extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )
    }
}
