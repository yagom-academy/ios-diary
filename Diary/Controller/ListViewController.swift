//
//  Diary - ListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ListViewController: UIViewController {
    private lazy var mainView = MainView.init(frame: view.bounds)
    private var diaries: [Diary] = [] {
        didSet {
            searchedDiaries = diaries
        }
    }
    
    private lazy var searchedDiaries: [Diary] = [] {
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
        mainView.searchBar.delegate = self
        mainView.tableView.register(ListTableViewCell.self,
                                    forCellReuseIdentifier: "\(ListTableViewCell.self)")
        configureNavigationBar()
        readDiaryDatas()
    }
    
    private func configureNavigationBar() {
        self.title = "일기장"
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add,
                                         target: self,
                                         action: #selector(touchPlusButton))
        self.navigationItem.rightBarButtonItem = plusButton
    }
    
    private func readDiaryDatas() {
        do {
            diaries = try CoreDataManager.shared.read().compactMap {
                return Diary(title: $0.title ?? "",
                             body: $0.body ?? "",
                             text: $0.text ?? "",
                             createdAt: $0.createdAt,
                             id: $0.id,
                             weather: Weather(main: $0.weatherModel?.main,
                                              iconID: $0.weatherModel?.iconID,
                                              iconImage: $0.weatherModel?.iconImage))
            }
        } catch {
            showErrorAlert("일기를 불러올 수 없습니다")
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
        return searchedDiaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ListTableViewCell.self)", for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureContents(searchedDiaries[indexPath.row])
        
        return cell
    }
}
// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let editViewController = EditViewController(diary: searchedDiaries[indexPath.row])
        
        editViewController.delegate = self
        self.navigationController?.pushViewController(editViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let share = UIContextualAction(style: .normal, title: "") { (_, _, success: @escaping (Bool) -> Void) in
            let title = self.searchedDiaries[indexPath.row].title
            let body = self.searchedDiaries[indexPath.row].body
            let diary = "\(title)\n\(body)"
            let shareActivity = UIActivityViewController(activityItems: [diary], applicationActivities: nil)
            
            self.present(shareActivity, animated: true)
            success(true)
        }
        
        let delete = UIContextualAction(style: .normal, title: "") { (_, _, success: @escaping (Bool) -> Void) in
            do {
                try CoreDataManager.shared.delete(self.searchedDiaries[indexPath.row])
                self.searchedDiaries.remove(at: indexPath.row)
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

extension ListViewController: DiaryViewControllerDelegate {
    func updateView() {
        readDiaryDatas()
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let keyword = searchBar.text else {
            return
        }
        if keyword.trimmingCharacters(in: .whitespaces).isEmpty {
                   searchedDiaries = diaries
        } else {
            searchedDiaries = []
            searchedDiaries = diaries.filter {
                $0.title.contains(keyword) || $0.body.contains(keyword)
            }
        }
    }
}
