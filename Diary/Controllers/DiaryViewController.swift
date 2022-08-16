//
//  Diary - ViewController.swift
//  Created by Finnn, 수꿍 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class DiaryViewController: UIViewController {
    
    // MARK: - Properties

    var dataSource: UITableViewDiffableDataSource<Section, DiarySampleData>?
    let diarySampleData: [DiarySampleData]? = JSONData.parse(name: "sample")
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = DiaryView()
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItems()
        configureDelegate()
        registerTableView()
        configureDataSource()
    }

    // MARK: - Methods
    
    private func configureNavigationItems() {
        title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(plusButtonDidTapped))
    }
    
    private func configureDelegate() {
        guard let view = view as? DiaryView else {
            return
        }
        
        view.tableView.delegate = self
    }
    
    @objc private func plusButtonDidTapped() {
        goToDiaryContentsViewController()
    }
    
    private func goToDiaryContentsViewController() {
        navigationController?.pushViewController(DiaryContentsViewController(), animated: true)
    }
    
    private func configureDataSource() {
        guard let view = view as? DiaryView,
              let diarySampleData = self.diarySampleData else {
            return
        }
        
        let tableView = view.tableView
        
        dataSource = UITableViewDiffableDataSource<Section, DiarySampleData>(tableView: tableView, cellProvider: { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell",
                                                           for: indexPath) as? CustomCell else {
                return nil
            }
            cell.titleLabel.text = item.title
            cell.dateLabel.text = item.createdAt.formatToStringDate()
            cell.contentLabel.text = item.body
            cell.accessoryType = .disclosureIndicator
            
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, DiarySampleData>()
        snapshot.appendSections([.main])
        snapshot.appendItems(diarySampleData)
        
        dataSource?.apply(snapshot)
    }
    
    private func registerTableView() {
        guard let view = view as? DiaryView else {
            return
        }
        
        let tableView = view.tableView
        
        tableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.dataSource = dataSource
    }
}

extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
