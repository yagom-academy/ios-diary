//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryViewController: UIViewController {
    private var diaryData: [DiaryData] = []
    private var dataSource: UITableViewDiffableDataSource<Section, DiaryData>?
    private var coreDataManager: CoreDataManager = CoreDataManager()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        configureDataSource()
        configureSnapshot()
        setTableView()
        configureTableViewConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDiaryData()
    }
    
    @IBAction func tapAddBarButtonItem(_ sender: UIBarButtonItem) {
        coreDataManager.create()
        diaryData = coreDataManager.fetch()
        let detailViewController = storyboard?.instantiateViewController(identifier: "detailViewController") as? DetailViewController ?? DetailViewController()
        detailViewController.diaryData = self.diaryData.last
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    private func getDiaryData() {
        diaryData = coreDataManager.fetch()
        DispatchQueue.main.async {
            self.configureSnapshot()
        }
    }
    
    private func configureTableViewConstraint() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.register(UINib(nibName: "DiaryTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "diaryTableViewCell")
    }
}

// MARK: - TableView Delegate
extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailViewController: DetailViewController =
                storyboard?.instantiateViewController(withIdentifier: "detailViewController")
                as? DetailViewController else { return }
        detailViewController.diaryData = diaryData[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - TableView DataSource
extension DiaryViewController {
    private enum Section {
        case main
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, DiaryData>(tableView: tableView,
                                                   cellProvider: { tableView, indexPath, data in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "diaryTableViewCell",
                                                           for: indexPath) as? DiaryTableViewCell
            else {
                return UITableViewCell()
            }
            cell.configureCell(data: data)
            
            return cell
        })
    }
    
    private func configureSnapshot() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, DiaryData>()
        snapShot.appendSections([.main])
        snapShot.appendItems(diaryData)
//        snapShot.reloadSections([.main])
        dataSource?.apply(snapShot, animatingDifferences: false)
    }
}
