//
//  Diary - DiaryViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class DiaryViewController: UIViewController, DiaryProtocol {
    private lazy var tableView = DiaryTableView(delegate: self)
    
    private lazy var dataSource = DiaryDataSource(tableView: tableView) {
        tableView, indexPath, itemIdentifier in
        return self.setUpDataSource(tableView: tableView,
                                    indexPath: indexPath,
                                    itemIdentifier: itemIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setUpView()
        navigationController?.setUpNavigationController(viewController: self)
        setUpRefreshControll()

        LocationManager.agree(viewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataSource.updataTableView(tableView: tableView)
    }
    
    private func setUpDataSource(tableView: UITableView, indexPath: IndexPath, itemIdentifier: DiaryDTO) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DiaryCell.identifier, for: indexPath) as? DiaryCell {
            cell.configure(data: itemIdentifier)
            
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.layout(view: view)
    }
    
    private func setUpRefreshControll() {
        let refresh = UIRefreshControl()
        
        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.setUpTableView(refresh: refresh)
    }

    @objc private func pullToRefresh() {
        dataSource.setUpCoreData(tableView: tableView)
    }
}

// MARK: - UINavigationController
private extension UINavigationController {
    private enum Const {
        static let navigationTitle = "일기장"
        static let registerButton = "+"
    }
    
    func setUpNavigationController(viewController: UIViewController) {
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
            
            viewController.navigationItem.rightBarButtonItem = registerButton
        }
        
        viewController.navigationItem.title = Const.navigationTitle
        setUpRightItem()
    }
    
    @objc private func moveRegisterViewController() {
        let viewContoller = UpdateViewController()
        
        pushViewController(viewContoller, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? DiaryCell,
              let diaryData = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        let viewContoller = UpdateViewController(diaryData: diaryData)
        
        cell.isSelected = false
        
        navigationController?.pushViewController(viewContoller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? DiaryCell else {
            return nil
        }
        
        let cellData = cell.extractData()
        
        func makeContextualAction() -> [UIContextualAction] {
            let deleteAction = makeAction(title: "Delete", style: .destructive) { [weak self] in
                DiaryDAO.shared.delete(identifier: cellData.identifier?.uuidString)
                self?.dataSource.setUpCoreData(tableView: tableView)
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

// MARK: - CLLocationManagerDelegate
extension DiaryViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else {
            return
        }
        
        Location.shared.configure(lat: location.latitude, lon: location.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(title: "사용자의 위치를 가져올수 없습니다.")
    }
}
