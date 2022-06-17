//
//  Diary - DiaryViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryViewController: UIViewController {
    enum Const {
        static let navigationTitle = "일기장"
        static let registerButton = "+"
    }
    
    private let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<Int, DiaryData>?
    
    override func loadView() {
        super.loadView()
        setUpDataSource()
        setUpTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setUpNavigationController()
        setUpTableViewLayout()
        setUpSampleData()
    }
    
    private func setUpDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, DiaryData>(tableView: tableView) {
            tableView, indexPath, itemIdentifier in
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: DiaryCell.identifier,
                                                        for: indexPath) as? DiaryCell {
                cell.configure(data: itemIdentifier)
                return cell
            }
            
            return tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier,
                                                 for: indexPath)
        }
    }
    
    private func setUpTableView() {
        tableView.register(DiaryCell.self)
        tableView.register(UITableViewCell.self)
    }
    
    private func setUpNavigationController() {
        func setUpRightItem() {
            let weight = UIFont.systemFont(ofSize: 35, weight: .light)
            let attributes = [NSAttributedString.Key.font: weight]
            let registerButton = UIBarButtonItem(title: Const.registerButton,
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(moveRegisterViewController))

            registerButton.setTitleTextAttributes(attributes, for: .normal)
            
            navigationItem.rightBarButtonItem = registerButton
        }
        
        navigationItem.title = Const.navigationTitle
        setUpRightItem()
    }
    
    @objc private func moveRegisterViewController() {
        let viewContoller = RegisterViewController(backButtonTitle: navigationItem.title)
        let navigationController = UINavigationController(rootViewController: viewContoller)
        
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true)
    }
    
    private func setUpTableViewLayout() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setUpSampleData() {
        guard let sampleData = SampleData.get() else {
            return
        }
        
        setUpSanpshot(data: sampleData)
    }
    
    private func setUpSanpshot(data: [DiaryData]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, DiaryData>()
        
        snapshot.appendSections([.zero])
        snapshot.appendItems(data)
        
        dataSource?.apply(snapshot)
    }
}
