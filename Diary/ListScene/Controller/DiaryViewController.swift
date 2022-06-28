//
//  Diary - DiaryViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryViewController: UIViewController, DiaryProtocol {
    enum Const {
        static let navigationTitle = "일기장"
        static let registerButton = "+"
    }
    
    private let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<Int, DiaryDTO>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setUpNavigationController()
        setUpTableView()
        setUpTableViewLayout()
        setUpDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpCoreData()
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setUpNavigationController() {
        func setUpRightItem() {
            let weight = UIFont.systemFont(ofSize: 35, weight: .light)
            let attributes = [NSAttributedString.Key.font: weight]
            let registerButton = UIBarButtonItem(
                title: Const.registerButton,
                style: .plain,
                target: self,
                action: #selector(moveRegisterViewController)
            )
            
            registerButton.setTitleTextAttributes(attributes, for: .normal)
            
            navigationItem.rightBarButtonItem = registerButton
        }
        
        navigationItem.title = Const.navigationTitle
        setUpRightItem()
    }
    
    @objc private func moveRegisterViewController() {
        let viewContoller = UpdateViewController()
        
        navigationController?.pushViewController(viewContoller, animated: true)
    }
    
    private func setUpTableView() {
        tableView.register(DiaryCell.self)
        tableView.register(UITableViewCell.self)
        
        tableView.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setUpTableViewLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setUpDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, DiaryDTO>(tableView: tableView) {
            tableView, indexPath, itemIdentifier in
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: DiaryCell.identifier, for: indexPath) as? DiaryCell {
                cell.configure(data: itemIdentifier)
                
                return cell
            }
            
            return tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        }
    }
    
    private func setUpSampleData() {
        guard let sampleData: [DiaryDTO] = AssetManager.get() else {
            return
        }
        
        setUpSanpshot(data: sampleData)
    }
    
    private func setUpCoreData() {
        guard let coreData = DiaryDAO.shared.read() else {
            return
        }
        
        setUpSanpshot(data: coreData)
    }
    
    private func setUpSanpshot(data: [DiaryDTO]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, DiaryDTO>()
        
        snapshot.appendSections([.zero])
        snapshot.appendItems(data)
        
        dataSource?.apply(snapshot)
    }
}

extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? DiaryCell,
              let diaryData = dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        
        let viewContoller = UpdateViewController(diaryData: diaryData)
        
        cell.isSelected = false
        
        navigationController?.pushViewController(viewContoller, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? DiaryCell else {
            return nil
        }
        
        let cellData = cell.extractData()
        
        func makeContextualAction() -> [UIContextualAction] {
            let deleteAction = makeAction(title: "Delete", style: .destructive) { [weak self] in
                DiaryDAO.shared.delete(identifier: cellData.identifier?.uuidString)
                self?.setUpCoreData()
            }
            
            let cancelAction = makeAction(title: "Cancel", style: .cancel)
            
            let delete = UIContextualAction(style: .destructive, title: "Delete") {
                [weak self] (_, _, completion) in
                self?.showAlert(title: "진짜요?",
                                message: "정말로 삭제 하시겠어요?",
                                actions: [cancelAction, deleteAction])
                completion(true)
            }
            
            let share = UIContextualAction(style: .normal, title: "Share") {
                [weak self] (_, _, completion) in
                self?.showActivity(title: cellData.title)
                completion(true)
            }
            
            return [delete, share]
        }
        
        let config = UISwipeActionsConfiguration(actions: makeContextualAction())
        
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
}
