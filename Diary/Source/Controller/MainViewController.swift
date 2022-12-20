//
//  Diary - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
    let mainDiaryView = MainDiaryView()
    var diaries: [Diary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = mainDiaryView
        configureNavigationItem()
        setUpTableView()
        decodeDiaryData()
    }
    
    func setUpTableView() {
        mainDiaryView.diaryTableView.dataSource = self
    }
    
    func decodeDiaryData() {
        guard let dataAsset = NSDataAsset(name: "sample") else { return }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            diaries = try decoder.decode([Diary].self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func configureNavigationItem() {
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: nil)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CustomDiaryCell = tableView.dequeueReusableCell(
            withIdentifier: CustomDiaryCell.identifier,
            for: indexPath
        ) as? CustomDiaryCell else {
            return UITableViewCell()
        }
        
        let diary = diaries[indexPath.row]
        
        cell.configureCell(with: diary)
        
        return cell
    }
}
