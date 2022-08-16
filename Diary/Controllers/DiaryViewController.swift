//
//  Diary - ViewController.swift
//  Created by Finnn, 수꿍 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class DiaryViewController: UIViewController {
    
    // MARK: - Properties
    
    var tableView: UITableView?
    var dataSource: UITableViewDiffableDataSource<Section, DiarySampleData>?
    let diarySampleData: [DiarySampleData]? = JSONData.parse(name: "sample")
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    
        title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .plain,
                                                            target: nil,
                                                            action: #selector(plusButtonDidTapped))
        
        configureTableView()
        registerTableView()
        configureDataSource()
        configureUI()
    }

    // MARK: - Methods
    
    @objc private func plusButtonDidTapped() {
        
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: view.bounds,
                                style: .plain)
        tableView?.delegate = self
        
        guard let tableView = tableView else {
            return
        }
        
        view.addSubview(tableView)
    }
    
    private func configureDataSource() {
        guard let tableView = tableView,
              let diarySampleData = self.diarySampleData else {
            return
        }
        
        dataSource = UITableViewDiffableDataSource<Section, DiarySampleData>(tableView: tableView, cellProvider: { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell",
                                                           for: indexPath) as? CustomCell else {
                return nil
            }
            cell.titleLabel.text = item.title
            cell.dateLabel.text = String(item.createdAt)
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
        guard let tableView = tableView else {
            return
        }
        
        tableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.dataSource = dataSource
    }
    
    private func configureUI() {
        guard let tableView = tableView else {
            return
        }

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
