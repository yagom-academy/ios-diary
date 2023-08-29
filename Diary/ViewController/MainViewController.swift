//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var sample: [Sample] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        tableView.dataSource = self
        tableView.delegate = self
        decodeJSON()

    }

    @IBAction func tapAddButton(_ sender: Any) {
        
    }
    
    private func registerNib() {
        tableView.register(UINib(nibName: "DiaryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    private func decodeJSON() {
        let jsonDecoder = JSONDecoder()
        guard let dataAsset = NSDataAsset(name: "sample") else { return }
        
        do {
            self.sample = try jsonDecoder.decode([Sample].self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
        
        self.tableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sample.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DiaryTableViewCell else {
            return UITableViewCell()
        }
        
        let sample: Sample = self.sample[indexPath.row]
        cell.configureLabel(sample: sample)
        
        return cell
    }
}

