//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    private lazy var mainView = MainView.init(frame: view.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainView
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
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
