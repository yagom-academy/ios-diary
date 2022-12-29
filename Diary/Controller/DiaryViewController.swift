//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryViewController: UIViewController {
    private var sampleData: [SampleData] = []
    private var dataSource: UITableViewDiffableDataSource<Section, SampleData>?
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSampleData()
        view.addSubview(tableView)
        configureDataSource()
        configureSnapshot()
        setTableView()
        configureTableViewConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
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
    
    private func getSampleData() {
        let asset = NSDataAsset(name: "sample")
        guard let data = asset?.data else { return }
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            sampleData = try jsonDecoder.decode([SampleData].self, from: data)
        } catch {
            print(error)
        }
    }
}

// MARK: - TableView Delegate
extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailViewController: DetailViewController =
                storyboard?.instantiateViewController(withIdentifier: "DetailView")
                as? DetailViewController else { return }
        detailViewController.delegate = self
        detailViewController.diaryData = sampleData[indexPath.row]
        detailViewController.indexPath = indexPath
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension DiaryViewController: DetailViewControllerDelegate {
    func sendData(title: String, body: String, indexPath: IndexPath) {
        sampleData[indexPath.row].title = title
        sampleData[indexPath.row].body = body
    }
}


// MARK: - TableView DataSource
extension DiaryViewController {
    private enum Section {
        case main
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, SampleData>(tableView: tableView,
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
        var snapShot = NSDiffableDataSourceSnapshot<Section, SampleData>()
        snapShot.appendSections([.main])
        snapShot.appendItems(sampleData)
        dataSource?.apply(snapShot)
    }
}

