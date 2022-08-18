//
//  Diary - ViewController.swift
//  Created by Finnn, 수꿍 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class DiaryViewController: UIViewController {
    
    // MARK: - Properties

    var dataSource: UITableViewDiffableDataSource<Section, DiarySampleData>?
    let diarySampleData: [DiarySampleData]? = JSONData.parse(name: AssetData.sample)
    private let diaryView = DiaryListView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = diaryView
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItems()
        registerTableView()
        configureDataSource()
        configureDelgate()
    }

    // MARK: - Methods
    
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
