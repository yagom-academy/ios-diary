//
//  Diary - DiaryListViewController.swift
//  Created by Rowan, Harry. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    private let tableView = UITableView()
    private var diarySample: [DiarySample] = []
    private let sampleDecoder = DiarySampleDecoder()
    private let alertFactory: AlertFactoryService = AlertImplementation()
    private let alertDataMaker: AlertDataService = AlertViewDataMaker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRootView()
        setUpNavigationBar()
        setUpTableView()
        parseDiarySample()
    }

    private func setUpRootView() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
    }
    
    private func setUpNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDiary))
        
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc
    private func addDiary() {
        let nextViewController = DiaryContentViewController()
        
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DiaryListCell.self,
                           forCellReuseIdentifier: DiaryListCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        setUpTableViewLayout()
    }
    
    private func setUpTableViewLayout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safe.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
    }
    
    private func parseDiarySample() {
        guard let data = NSDataAsset(name: "sample")?.data else { return }
        
        let result = sampleDecoder.decode(type: [DiarySample].self, data: data)
        
        switch result {
        case .success(let sample):
            diarySample = sample            
        case .failure(let error):
            let alertViewData = alertDataMaker.decodeError(error)
            let alert = alertFactory.makeAlert(for: alertViewData)
            
            present(alert, animated: true)
        }
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diarySample.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: DiaryListCell.identifier,
                                 for: indexPath) as? DiaryListCell
        else { return UITableViewCell() }
        
        cell.configureLabels(with: diarySample[indexPath.row])
        
        return cell
    }
}

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController = DiaryContentViewController(diary: diarySample[indexPath.row])
        
        navigationController?.pushViewController(nextViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
