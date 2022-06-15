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
    
    private lazy var plusButton: UIBarButtonItem = {
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(touchPlusButton))
        
        return plusButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainView
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "\(ListTableViewCell.self)")
        configureNavigationBar()
        convert(parse())
    }
    
    private func configureNavigationBar() {
        self.title = "일기장"
        self.navigationItem.rightBarButtonItem = plusButton
    }
    
    @objc private func touchPlusButton() {
        let diaryViewController = DiaryViewController(diary: nil)
        
        self.navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    private func parse() -> [DiaryData]? {
        guard let asset = NSDataAsset(name: "sample") else {
            return nil
        }
        
        let jsonDecoder = JSONDecoder()
        
        guard let sample = try? jsonDecoder.decode([DiaryData].self, from: asset.data) else {
            return nil
        }
        
        return sample
    }
    
    private func convert(_ data: [DiaryData]?) {
        guard let diaryData = data else {
            return
        }
        
        var array: [Diary] = []
        
        for diaryData in diaryData {
            guard let doubleDate = diaryData.createdAt else {
                return
            }
            
            let stringDate = DateConverter.changeDateFormat(doubleDate)
            
            array.append(Diary(title: diaryData.title ?? "", body: diaryData.body ?? "", createdAt: stringDate))
        }
        
        self.diaryArray = array
    }
}

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

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let diaryViewController = DiaryViewController(diary: diaryArray[indexPath.row])
        
        self.navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.orientation.isLandscape {
            return UIScreen.main.bounds.width * 0.08
        } else {
            return UIScreen.main.bounds.width * 0.17
        }
    } 
}
