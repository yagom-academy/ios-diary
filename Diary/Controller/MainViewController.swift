//
//  Diary - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    private var dairySample: [DairySample] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpConstraints()
        setUpViewController()
    }

    private func configureUI() {
        view.addSubview(tableView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpViewController() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(didTappedRightAddButton))
    }
    
    private func decodeDairySample(filename: String) {
        let jsonDecoder = JSONDecoder()
        guard let asset = NSDataAsset(name: filename) else { return }
        guard let data = try? jsonDecoder.decode([DairySample].self, from: asset.data) else { return }
        
        dairySample = data
    }
    
    @objc
    private func didTappedRightAddButton() {
        let addDairyViewController = AddDairyViewController()
        
        navigationController?.pushViewController(addDairyViewController, animated: true)
    }
}

