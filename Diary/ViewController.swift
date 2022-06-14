//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    private lazy var mainView = MainView.init(frame: view.bounds)
    private var diaryArray: [Diary] = [] {
        didSet {
            mainView.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainView
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "\(ListTableViewCell.self)")
        convert(parse())
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
            guard let intDate = diaryData.createdAt else {
                return
            }
            
            let stringDate = "\(intDate)"
            
            array.append(Diary(title: diaryData.title ?? "", body: diaryData.body ?? "", createdAt: stringDate))
        }
        
        self.diaryArray = array
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return ListTableViewCell()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width * 0.17
    } 
}
