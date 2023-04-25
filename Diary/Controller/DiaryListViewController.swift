//
//  Diary - DiaryListViewController.swift
//  Created by Rowan, Harry. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class DiaryListViewController: UIViewController {
    let tableView = UITableView()
    var diarySample: [DiarySample] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRootView()
        setUpTableView()
        parseDiarySample()
    }

    private func setUpRootView() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        setUpTableViewLayout()
    }
    
    private func setUpTableViewLayout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safe.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
    }
    
    private func parseDiarySample() {
        let decoder = JSONDecoder()
        
        do {
            guard let data = NSDataAsset(name: "sample")?.data else { return }
            
            diarySample = try decoder.decode([DiarySample].self, from: data)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension DiaryListViewController: UITableViewDelegate {

}
