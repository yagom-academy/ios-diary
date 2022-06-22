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
    
    private func readDiaryDatas() {
        do {
            diaryArray = try CoreDataManager.shared.read().compactMap {
                return Diary(title: $0.title ?? "",
                             body: $0.body ?? "",
                             text: $0.text ?? "",
                             createdAt: $0.createdAt,
                             id: $0.id)
            }
            diaryArray.reverse()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc private func touchPlusButton() {
        let addViewController = AddViewController()
        
        addViewController.delegate = self
        self.navigationController?.pushViewController(addViewController, animated: true)
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let share = UIContextualAction(style: .normal, title: "") { (_, _, success: @escaping (Bool) -> Void) in
            let title = self.diaryArray[indexPath.row].title
            let body = self.diaryArray[indexPath.row].body
            
            let diary = "\(title)\n\(body)"
            let shareActivity = UIActivityViewController(activityItems: [diary], applicationActivities: nil)
            self.present(shareActivity, animated: true)
            success(true)
        }
        
        let delete = UIContextualAction(style: .normal, title: "") { (_, _, success: @escaping (Bool) -> Void) in
            do {
                try CoreDataManager.shared.delete(self.diaryArray[indexPath.row])
                self.diaryArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                self.showErrorAlert("삭제에 실패했습니다")
            }
            success(true)
        }
        
        share.backgroundColor = .systemBlue
        share.image = UIImage(systemName: "square.and.arrow.up")
        delete.backgroundColor = .systemRed
        delete.image = UIImage(systemName: "trash.fill")

        return UISwipeActionsConfiguration(actions: [delete, share])
    }
}

extension ListViewController: DataSendable {
    func updateView() {
        readDiaryDatas()
    }
}
