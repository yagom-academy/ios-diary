//
//  Diary - DiaryViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryViewController: UIViewController {
    enum Constant {
        static let navigationTitle = "일기장"
        static let registerButton = "+"
    }
    
    private let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<Int, DiaryData>?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setUpDataSource()
        setUpTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setUpNavigationController()
        setUpTableViewLayout()
        
        guard let diaryData = AssetManager().getData() else {
            return
        }
        
        setUpSanpshot(data: diaryData)
    }
    
    private func setUpTableView() {
        tableView.register(DiaryCell.self, forCellReuseIdentifier: DiaryCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        
        tableView.dataSource = dataSource
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
    
    private func setUpDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, DiaryData>(tableView: tableView) {
            tableView, indexPath, itemIdentifier in
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: DiaryCell.identifier, for: indexPath) as? DiaryCell {
                cell.configure(data: itemIdentifier)
                return cell
            }
            
            return tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        }
    }
    
    private func setUpSanpshot(data: [DiaryData]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, DiaryData>()
        
        snapshot.appendSections([.zero])
        snapshot.appendItems(data)
        
        dataSource?.apply(snapshot)
    }
    
    private func setUpNavigationController() {
        func setUpRightItem() {
            let weight = UIFont.systemFont(ofSize: 35, weight: .light)
            let attributes = [NSAttributedString.Key.font: weight]
            let registerButton = UIBarButtonItem(title: Constant.registerButton, style: .plain, target: self, action: #selector(moveRegisterViewController))

            registerButton.setTitleTextAttributes(attributes, for: .normal)
            
            navigationItem.rightBarButtonItem = registerButton
        }
        
        navigationItem.title = Constant.navigationTitle
        setUpRightItem()
    }
    
    @objc private func moveRegisterViewController() {
        let viewContoller = RegisterViewController(backButtonTitle: navigationItem.title)
        let navigationController = UINavigationController(rootViewController: viewContoller)
        
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true)
    }
}
