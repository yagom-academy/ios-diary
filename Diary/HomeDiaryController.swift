//
//  Diary - ViewController.swift
//  Created by Andrew, Brody.
// 

import UIKit

class HomeDiaryController: UIViewController {
    private let diaryTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diaryTableView.dataSource = self
    }
}

extension HomeDiaryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
