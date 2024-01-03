//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource {
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    

}

extension HomeViewController {
    private func configureUI() {
        navigationItemInit()
        tableInit()
        autoLayoutInit()
    }
    
    private func navigationItemInit() {
        let rightItemButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: nil, action: nil)
        
        self.navigationItem.title = "일기장"
        self.navigationItem.rightBarButtonItem = rightItemButton
    }
    
    private func tableInit() {
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
    }
    
    private func autoLayoutInit() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}

