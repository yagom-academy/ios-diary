//
//  Diary - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    private lazy var mainView = MainView(frame: view.bounds)
    private var diaryList = [Diary]()
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpTableView()
        setUpDiaryList()
    }
        
    private func setUpNavigationBar() {
        title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddButton)
        )
    }
    
    private func setUpTableView() {
        mainView.baseTableView.dataSource = self
        mainView.baseTableView.delegate = self
    }
    
    private func setUpDiaryList() {
        if let data: [Diary] = JSONParser().decode(from: "sample") {
            diaryList = data
        }
    }
    
    @objc private func didTapAddButton() {
        
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryCell.identifier) as? DiaryCell else {
            return UITableViewCell()
        }
        
        cell.setUpContents(data: diaryList[indexPath.row])
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let diary = diaryList[safe: indexPath.row] else {
            return
        }
        
        let detailVC = DetailViewController(diary: diary)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
