//
//  Diary - ListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ListViewController: UIViewController {
    private lazy var mainView = MainView.init(frame: view.bounds)
    private var diaryArray: [Diary] = [] {
        didSet {
            mainView.tableView.reloadData()
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
        appendDiary(parsedData())
    }
    
    private func configureNavigationBar() {
        self.title = "일기장"
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(touchPlusButton))
        self.navigationItem.rightBarButtonItem = plusButton
    }
    
    @objc private func touchPlusButton() {
        let addViewController = AddViewController()
        
        self.navigationController?.pushViewController(addViewController, animated: true)
    }
    
    private func parsedData() -> [DiaryData]? {
        guard let asset = NSDataAsset(name: "sample") else {
            return nil
        }
        
        let jsonDecoder = JSONDecoder()
        
        guard let sample = try? jsonDecoder.decode([DiaryData].self, from: asset.data) else {
            return nil
        }
        
        return sample
    }
    
    private func appendDiary(_ data: [DiaryData]?) {
        guard let diaryDatas = data else {
            return
        }
        
        let array: [Diary] = diaryDatas.compactMap { diaryData in
            guard let doubleDate = diaryData.createdAt else {
                return nil
            }
            
            let date = Date(timeIntervalSince1970: doubleDate)
            let stringDate = date.dateToKoreanString
            
            return Diary(title: diaryData.title ?? "", body: diaryData.body ?? "", createdAt: stringDate)
        }
        
        self.diaryArray = array
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
        
        self.navigationController?.pushViewController(editViewController, animated: true)
    }
}
