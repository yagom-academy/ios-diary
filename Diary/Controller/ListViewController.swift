//
//  Diary - ListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

protocol DataSendable: NSObject {
    func updateView()
}

final class ListViewController: UIViewController {
    private lazy var mainView = MainView.init(frame: view.bounds)
    private var diaryArray: [Diary] = [] {
        didSet {
            DispatchQueue.main.async {
                self.mainView.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialView()
    }
    
    private func setInitialView() {
        self.view = mainView
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "\(ListTableViewCell.self)")
        configureNavigationBar()
        readDiaryDatas()
    }
    
    private func configureNavigationBar() {
        self.title = "일기장"
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(touchPlusButton))
        self.navigationItem.rightBarButtonItem = plusButton
    }
    
    @objc private func touchPlusButton() {
        let addViewController = AddViewController()
        
        addViewController.delegate = self
        self.navigationController?.pushViewController(addViewController, animated: true)
    }
    
    private func readDiaryDatas() {
        do {
            diaryArray = try CoreDataManager.shared.read().compactMap {
                return Diary(title: $0.title ?? "",
                             body: $0.body ?? "",
                             createdAt: $0.createdAt,
                             id: $0.id)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ListTableViewCell.self)", for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureContents(diaryArray[indexPath.row])
        
        return cell
    }
}
// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let editViewController = EditViewController(diary: diaryArray[indexPath.row])
        
        editViewController.delegate = self
        self.navigationController?.pushViewController(editViewController, animated: true)
    }
}

extension ListViewController: DataSendable {
    func updateView() {
        readDiaryDatas()
    }
}
